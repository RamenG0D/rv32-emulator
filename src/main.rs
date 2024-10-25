use arg_parser::{ProgramCommands, RunBinCmd, RunCommand};
use riscv_vm::{cpu::Cpu, trap::Exception};
use std::io::Read;
use clap::Parser;

pub mod arg_parser;

fn run_bin(cmd: RunBinCmd) {
    // get the file's data
    let mut file = std::fs::File::open(cmd.bin_file).expect("Failed to open file? (idk why)");

    let mut buffer = Vec::new();
    file.read_to_end(&mut buffer).expect("Failed to read file contents");

    let mut cpu = Cpu::new();

    if cmd.debug {
        riscv_vm::logging::init_logging(riscv_vm::logging::log::LevelFilter::Debug);
    }

    cpu.initialize_dram(&buffer).expect("Failed to load program into cpu memory");

    println!("Starting the emulator");
    match cpu.run() {
        Ok(_) => (),
        Err(Exception::InstructionAccessFault) => (),
        Err(e) => {
            println!("Emulator has stopped with an error: {:?}", e);
        }
    }
    println!("Emulator has stopped");
}

fn main() {
    let commands = ProgramCommands::parse();

    match commands {
        ProgramCommands::RunCmd(run_cmd) => match run_cmd {
            RunCommand::Bin(cmd) => run_bin(cmd),
            RunCommand::Asm |
            RunCommand::Input => todo!(),
        }
    }
}
