use cmd::{VmArgs, VmCmd};
use devices::{
    clint::{Clint, MSIP, MTIME, MTIMECMP},
    plic::Plic,
    uart::{Uart, UART_IRQ},
    viritio::{Virtio, VIRTIO_IRQ},
};
use log::{error, info};
use riscv_vm::{
    bit_ops,
    cpu::{Cpu, Privilege, Riscv32Cpu},
    csr::{Csr, MEIP_BIT, MIE, MIP, MSIP_BIT, MSTATUS, MTIP_BIT, SEIP_BIT, SSIP_BIT, SSTATUS, STIP_BIT},
    interrupt::Interrupt,
    memory::dram::{Dram, Sizes, DRAM_BASE, DRAM_SIZE},
    trap::Exception,
};
use std::{io::Read, path::PathBuf};
use structopt::StructOpt;

pub mod cmd;
pub mod devices;

fn init_cpu(cpu: &mut Riscv32Cpu, bin_file: PathBuf, disk_file: Option<PathBuf>) {
	let mut buffer = Vec::new();

	let mut file = std::fs::File::open(bin_file).expect("Failed to read the binary file");
	file.read_to_end(&mut buffer)
		.expect("failed to read binary file contents");

	// setup the stack pointer for register 2
	*cpu.get_register_mut(2).unwrap() = (DRAM_BASE + DRAM_SIZE) - 1;
	cpu.add_device(Dram::new_device());
	cpu.add_device(Clint::new_device());
	cpu.add_device(Uart::new_device());
	cpu.add_device(Plic::new_device());
	cpu.add_device(Virtio::new_device());

	if let Some(dram) = cpu.get_device_mut::<Dram>() {
		info!("{:-^80}", "DRAM Initialization");
		info!("initializing dram with {} bytes", buffer.len());
		dram.initialize(&buffer);
		info!("{:-^80}", "");
	} else {
		error!("Failed to get dram device");
	}

	if let Some(df) = disk_file {
		buffer.clear();
		file = std::fs::File::open(df).expect("Failed to read the disk file");
		file.read_to_end(&mut buffer).expect("failed to read disk file contents");
		let disk = cpu.get_device_mut::<Virtio>().expect("Failed to get the system disk device");
		info!("{:-^80}", "Disk Initialization");
		info!("initializing disk with {} bytes", buffer.len());
		disk.initialize(&buffer);
		info!("{:-^80}", "");
	}
}

fn main() {
    let commands = VmArgs::from_args();

    if commands.debug {
        riscv_vm::init_logging(riscv_vm::log::LevelFilter::Debug);
    } else {
        riscv_vm::init_logging(riscv_vm::log::LevelFilter::Info);
    }

    match commands.cmd {
        VmCmd::Run {
            bin_file,
            disk_file,
            step,
        } => {
            let mut cpu = Riscv32Cpu::new();

            let check_ints = |cpu: &mut Riscv32Cpu| {
                {
                    let clint = cpu
                        .get_device::<Clint>()
                        .expect("Failed to get clint device");

                    let (mtime, mtimecmp) = (
                        clint
                            .read(MTIME, Sizes::Word)
                            .expect("Failed to read mtime"),
                        clint
                            .read(MTIMECMP, Sizes::Word)
                            .expect("Failed to read mtimecmp"),
                    );
                    // generate an interrupt if the mtime is greater than or equal to mtimecmp
                    // and the msip register is set to 1
                    let msip = clint.read(MSIP, Sizes::Word).expect("Failed to read msip");
                    let msip = (msip & MSIP_BIT) >> 3;
                    if mtime >= mtimecmp && msip == 1 {
                        return Some(Interrupt::MachineTimerInterrupt);
                    }
                }

                // 3.1.6.1 Privilege and Global Interrupt-Enable Stack in mstatus register
                // "When a hart is executing in privilege mode x, interrupts are globally enabled when
                // xIE=1 and globally disabled when xIE=0."
                match cpu.get_privilege() {
                    Privilege::Machine => {
                        // Check if the MIE bit is enabled.
                        // MSTATUS_MIE => 3rd bit
                        if bit_ops::get_bit(cpu.read_csr(MSTATUS), 3) == 0 {
                            return None;
                        }
                    }
                    Privilege::Supervisor => {
                        // Check if the SIE bit is enabled.
                        if bit_ops::get_bit(cpu.read_csr(SSTATUS), 1) == 0 {
                            return None;
                        }
                    }
                    _ => {}
                }

                // TODO: Take interrupts based on priorities.

                // Check external interrupt for uart and virtio.
                let mut irq = 0;

                {
                    let uart = cpu.get_device::<Uart>().expect("Failed to get uart device");
                    if uart.is_interrupting() {
                        irq = UART_IRQ;
                    }
                }

                {
                    let virtio = cpu
                        .get_device_mut::<Virtio>()
                        .expect("Failed to get virtio device");
                    if virtio.is_interrupting() {
                        // An interrupt is raised after a disk access is done.
                        Virtio::disk_access(cpu).expect("failed to access the disk");
                        irq = VIRTIO_IRQ;
                    }
                }

                if irq != 0 {
                    {
                        let plic = cpu
                            .get_device_mut::<Plic>()
                            .expect("Failed to get plic device");
                        // TODO: assume that hart is 0
                        // TODO: write a value to MCLAIM if the mode is machine
                        plic.update_pending(irq);
                    }
                    let c = cpu.state_mut();
                    c.write(MIP, c.read(MIP) | SEIP_BIT);
                }

                // 3.1.9 Machine Interrupt Registers (mip and mie)
                // "An interrupt i will be taken if bit i is set in both mip and mie, and if interrupts are
                // globally enabled. By default, M-mode interrupts are globally enabled if the hart’s
                // current privilege mode is less than M, or if the current privilege mode is M and the MIE
                // bit in the mstatus register is set. If bit i in mideleg is set, however, interrupts are
                // considered to be globally enabled if the hart’s current privilege mode equals the
                // delegated privilege mode (S or U) and that mode’s interrupt enable bit (SIE or UIE in
                // mstatus) is set, or if the current privilege mode is less than the delegated privilege
                // mode."
                let pending = cpu.get_interface().read_csr(MIE) & cpu.get_interface().read_csr(MIP);

                if (pending & MEIP_BIT) != 0 {
                    let c = cpu.state_mut();
                    c.write(MIP, c.read(MIP) & !MEIP_BIT);
                    return Some(Interrupt::MachineExternalInterrupt);
                }
                if (pending & MSIP_BIT) != 0 {
                    let c = cpu.state_mut();
                    c.write(MIP, c.read(MIP) & !MSIP_BIT);
                    return Some(Interrupt::MachineSoftwareInterrupt);
                }
                if (pending & MTIP_BIT) != 0 {
                    let c = cpu.state_mut();
                    c.write(MIP, c.read(MIP) & !MTIP_BIT);
                    return Some(Interrupt::MachineTimerInterrupt);
                }
                if (pending & SEIP_BIT) != 0 {
                    let c = cpu.state_mut();
                    c.write(MIP, c.read(MIP) & !SEIP_BIT);
                    return Some(Interrupt::SupervisorExternalInterrupt);
                }
                if (pending & SSIP_BIT) != 0 {
                    let c = cpu.state_mut();
                    c.write(MIP, c.read(MIP) & !SSIP_BIT);
                    return Some(Interrupt::SupervisorSoftwareInterrupt);
                }
                if (pending & STIP_BIT) != 0 {
                    let c = cpu.state_mut();
                    c.write(MIP, c.read(MIP) & !STIP_BIT);
                    return Some(Interrupt::SupervisorTimerInterrupt);
                }

                None
            };

			init_cpu(&mut cpu, bin_file, disk_file);

            println!("Starting the emulator");
            // check if the user specified step mode
            // if so then we will step through the program
            // and ask the user if they want to continue
            // after each step
            if step {
                loop {
                    cpu.dump_registers();
                    cpu.dump_csr();
                    match cpu.step() {
                        Ok(_) => (),
                        Err(Exception::InstructionAccessFault) => (),
                        Err(e) => {
                            error!(
                                "{:#X} Emulator has stopped with an error: {:?}",
                                cpu.get_pc().wrapping_sub(4),
                                e
                            );
                            break;
                        }
                    }
                    println!("Press enter to continue or type 'exit' to stop the emulator");
                    print!("> ");
                    use std::io::Write;
                    std::io::stdout().flush().unwrap();
                    let mut input = String::new();
                    std::io::stdin().read_line(&mut input).unwrap();
                    if input.trim() == "exit" {
                        break;
                    } else if input.trim() == "dump" {
                        cpu.dump_registers();
                        cpu.dump_csr();
                    } else if input.starts_with("show") { // input is "show <address>"
                        let mut parts = input.split_whitespace();
                        parts.next();
                        let address = parts.next().unwrap();
                        let address = u32::from_str_radix(address, 16).unwrap();
                        let value = cpu
                            .read(address, Sizes::Word, riscv_vm::cpu::AccessType::None)
                            .unwrap();
                        println!("Value at {:#X} is {:#X}", address, value);
                    } else if input.starts_with("con") { // "con <address>"
						// continues to the given address
						let mut parts = input.split_whitespace();
						parts.next();
						let address = parts.next().unwrap();
						let address = u32::from_str_radix(address, 16).unwrap();
						info!("Continuing to address {:#X}", address);
						while cpu.get_pc() != address {
							cpu.step().unwrap();
						}
					}
                }
            } else {
                while cpu.step().is_ok() {
                    if let Some(int) = check_ints(&mut cpu) {
                        int.take_trap(cpu.get_interface());
                    }
                }
            }
            cpu.dump_registers();
            println!("Emulator has stopped");
        }
        VmCmd::Completions {} => {
            let handle = std::io::stdout();
            let mut out_buffer: Box<dyn std::io::Write> = if let Some(path) = commands.output {
                Box::new(std::io::BufWriter::new(
                    std::fs::File::create(path).expect("Failed to create file"),
                ))
            } else {
                Box::new(std::io::BufWriter::new(handle))
            };
            fn get_shell() -> Option<structopt::clap::Shell> {
                std::env::var("SHELL").ok().and_then(|shell| {
                    let shell = shell.split('/').last().unwrap();
                    match shell {
                        "bash" => Some(structopt::clap::Shell::Bash),
                        "zsh" => Some(structopt::clap::Shell::Zsh),
                        "fish" => Some(structopt::clap::Shell::Fish),
                        "powershell" => Some(structopt::clap::Shell::PowerShell),
                        _ => None,
                    }
                })
            }

            VmArgs::clap().gen_completions_to(
                "rv32-emulator",
                get_shell().expect("Failed to get shell"),
                &mut out_buffer,
            );
        }
    }
}
