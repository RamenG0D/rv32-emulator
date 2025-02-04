//! The plic module contains the platform-level interrupt controller (PLIC). The plic connects all
//! external interrupts in the system to all hart contexts in the system, via the external interrupt
//! source in each hart. It's the global interrupt controller in a RISC-V system.

use log::debug;
use riscv_vm::{
    bus::{Device, VirtualDevice},
    memory::{dram::Sizes, virtual_memory::MemorySize},
    trap::Exception,
};

const PLIC_BASE: u32 = 0xC00_0000;
const PLIC_SIZE: u32 = 0x208000;

// Reference:
// "SiFive Interrupt Cookbook Version 1.0"
// https://sifive.cdn.prismic.io/sifive/0d163928-2128-42be-a75a-464df65e04e0_sifive-interrupt-cookbook.pdf
// "RISC-V Platform-Level Interrupt Controller Specification"
// https://github.com/riscv/riscv-plic-spec/blob/master/riscv-plic.adoc
//
// QEMU SiFive PLIC used in the virt machine:
// - https://github.com/qemu/qemu/blob/master/hw/intc/sifive_plic.c
// - https://github.com/qemu/qemu/blob/master/include/hw/intc/sifive_plic.h
/// The address for interrupt source priority. 1024 4-byte registers exist. Each interrupt into the
/// PLIC has a configurable priority, from 1-7, with 7 being the highest priority. A value of 0
/// means do not interrupt, effectively disabling that interrupt.
const SOURCE_PRIORITY: u32 = PLIC_BASE;
const SOURCE_PRIORITY_END: u32 = PLIC_BASE + 0xfff;

/// The address range for interrupt pending bits. 32 4-byte (1024 bits) registers exist.
///
/// https://github.com/riscv/riscv-plic-spec/blob/master/riscv-plic.adoc#memory-map
/// base + 0x001000: Interrupt Pending bit 0-31
/// base + 0x00107C: Interrupt Pending bit 992-1023
const PENDING: u32 = PLIC_BASE + 0x1000;
const PENDING_END: u32 = PLIC_BASE + 0x107f;

/// The address range for enable registers. The maximum number of contexts is 15871 but this PLIC
/// supports only 2 contexts.
///
/// https://github.com/riscv/riscv-plic-spec/blob/master/riscv-plic.adoc#memory-map
/// base + 0x002000: Enable bits for sources 0-31 on context 0
/// base + 0x002004: Enable bits for sources 32-63 on context 0
/// ...
/// base + 0x00207F: Enable bits for sources 992-1023 on context 0
/// base + 0x002080: Enable bits for sources 0-31 on context 1
/// base + 0x002084: Enable bits for sources 32-63 on context 1
/// ...
/// base + 0x0020FF: Enable bits for sources 992-1023 on context 1
const ENABLE: u32 = PLIC_BASE + 0x2000;
const ENABLE_END: u32 = PLIC_BASE + 0x20ff;

/// The address range for priority thresholds and claim/complete registers. The maximum number of
/// contexts is 15871 but this PLIC supports only 2 contexts.
///
/// https://github.com/riscv/riscv-plic-spec/blob/master/riscv-plic.adoc#memory-map
/// base + 0x200000: Priority threshold for context 0
/// base + 0x200004: Claim/complete for context 0
/// base + 0x200008: Reserved
/// ...
/// base + 0x200FFC: Reserved
/// base + 0x201000: Priority threshold for context 1
/// base + 0x201004: Claim/complete for context 1
const THRESHOLD_AND_CLAIM: u32 = PLIC_BASE + 0x200000;
const THRESHOLD_AND_CLAIM_END: u32 = PLIC_BASE + 0x201007;

const WORD_SIZE: u32 = 0x4;
const CONTEXT_OFFSET: u32 = 0x1000;
const SOURCE_NUM: u32 = 1024;

/// The platform-level-interrupt controller (PLIC).
pub struct Plic {
    /// The interrupt priority for each interrupt source. A priority value of 0 is reserved to mean
    /// "never interrupt" and effectively disables the interrupt. Priority 1 is the lowest active
    /// priority, and priority 7 is the highest.
    priority: [u32; SOURCE_NUM as usize],
    /// Interrupt pending bits. If bit 1 is set, a global interrupt 1 is pending. A pending bit in
    /// the PLIC core can be cleared by setting the associated enable bit then performing a claim.
    pending: [u32; 32],
    /// Interrupt Enable Bit of Interrupt Source #0 to #1023 for 2 contexts.
    enable: [u32; 64],
    /// The settings of a interrupt priority threshold of each context. The PLIC will mask all PLIC
    /// interrupts of a priority less than or equal to `threshold`.
    threshold: [u32; 2],
    /// The ID of the highest priority pending interrupt or zero if there is no pending interrupt
    /// for each context.
    claim: [u32; 2],
}

impl Plic {
    /// Create a new PLIC object.
    pub fn new() -> Self {
        Self {
            priority: [0; 1024],
            pending: [0; 32],
            enable: [0; 64],
            threshold: [0; 2],
            claim: [0; 2],
        }
    }

    pub fn new_device() -> VirtualDevice {
        VirtualDevice::new(Box::new(Self::new()), PLIC_BASE, PLIC_SIZE)
    }

    /// Sets IRQ bit in `pending`.
    pub fn update_pending(&mut self, irq: u32) {
        let index = irq.wrapping_div(WORD_SIZE);
        self.pending[index as usize] |= 1 << irq;

        self.update_claim(irq);
    }

    /// Clears IRQ bit in `pending`.
    pub fn clear_pending(&mut self, irq: u32) {
        let index = irq.wrapping_div(WORD_SIZE);
        self.pending[index as usize] &= !(1 << irq);

        self.update_claim(0);
    }

    /// Sets IRQ bit in `claim` for context 1.
    pub fn update_claim(&mut self, irq: u32) {
        // TODO: Support highest priority to the `claim` register.
        // claim[1] is claim/complete registers for S-mode (context 1). SCLAIM.
        if self.is_enable(1, irq) || irq == 0 {
            self.claim[1] = irq;
        }
    }

    /// Returns true if the enable bit for the `irq` of the `context` is set.
    pub fn is_enable(&self, context: u32, irq: u32) -> bool {
        let index = (irq.wrapping_rem(SOURCE_NUM)).wrapping_div(WORD_SIZE * 8);
        let offset = (irq.wrapping_rem(SOURCE_NUM)).wrapping_rem(WORD_SIZE * 8);
        ((self.enable[(context * 32 + index) as usize] >> offset) & 1) == 1
    }

    /// Load `size`-bit data from a register located at `addr` in PLIC.
    pub fn read(&self, addr: u32, size: Sizes) -> Result<u32, Exception> {
        // TODO: should support byte-base access.
        if !matches!(size, Sizes::Word) {
            return Err(Exception::LoadAccessFault);
        }

        let addr = addr + PLIC_BASE;
        debug!("PLIC read: {:#X}", addr);

        match addr {
            SOURCE_PRIORITY..=SOURCE_PRIORITY_END => {
                if (addr - SOURCE_PRIORITY).wrapping_rem(WORD_SIZE) != 0 {
                    return Err(Exception::LoadAccessFault);
                }
                let index = (addr - SOURCE_PRIORITY).wrapping_div(WORD_SIZE);
                Ok(self.priority[index as usize])
            }
            PENDING..=PENDING_END => {
                if (addr - PENDING).wrapping_rem(WORD_SIZE) != 0 {
                    return Err(Exception::LoadAccessFault);
                }
                let index = (addr - PENDING).wrapping_div(WORD_SIZE);
                Ok(self.pending[index as usize])
            }
            ENABLE..=ENABLE_END => {
                if (addr - ENABLE).wrapping_rem(WORD_SIZE) != 0 {
                    return Err(Exception::LoadAccessFault);
                }
                let index = (addr - ENABLE).wrapping_div(WORD_SIZE);
                Ok(self.enable[index as usize])
            }
            THRESHOLD_AND_CLAIM..=THRESHOLD_AND_CLAIM_END => {
                let context = (addr - THRESHOLD_AND_CLAIM).wrapping_div(CONTEXT_OFFSET);
                let offset = addr - (THRESHOLD_AND_CLAIM + CONTEXT_OFFSET * context);
                if offset == 0 {
                    Ok(self.threshold[context as usize])
                } else if offset == 4 {
                    Ok(self.claim[context as usize])
                } else {
                    return Err(Exception::LoadAccessFault);
                }
            }
            _ => Err(Exception::LoadAccessFault),
        }
    }

    /// Store `size`-bit data to a register located at `addr` in PLIC.
    pub fn write(&mut self, addr: u32, value: u32, size: Sizes) -> Result<(), Exception> {
        // TODO: should support byte-base access.
        if !matches!(size, Sizes::Word) {
            return Err(Exception::StoreAccessFault);
        }

        let addr = addr + PLIC_BASE;
        debug!("PLIC write: {:#X}", addr);

        match addr {
            SOURCE_PRIORITY..=SOURCE_PRIORITY_END => {
                if (addr - SOURCE_PRIORITY).wrapping_rem(WORD_SIZE) != 0 {
                    return Err(Exception::StoreAccessFault);
                }
                let index = (addr - SOURCE_PRIORITY).wrapping_div(WORD_SIZE);
                self.priority[index as usize] = value;
            }
            PENDING..=PENDING_END => {
                if (addr - PENDING).wrapping_rem(WORD_SIZE) != 0 {
                    return Err(Exception::StoreAccessFault);
                }
                let index = (addr - PENDING).wrapping_div(WORD_SIZE);
                self.pending[index as usize] = value;
            }
            ENABLE..=ENABLE_END => {
                if (addr - ENABLE).wrapping_rem(WORD_SIZE) != 0 {
                    return Err(Exception::StoreAccessFault);
                }
                let index = (addr - ENABLE).wrapping_div(WORD_SIZE);
                self.enable[index as usize] = value;
            }
            THRESHOLD_AND_CLAIM..=THRESHOLD_AND_CLAIM_END => {
                let context = (addr - THRESHOLD_AND_CLAIM).wrapping_div(CONTEXT_OFFSET);
                let offset = addr - (THRESHOLD_AND_CLAIM + CONTEXT_OFFSET * context);
                if offset == 0 {
                    self.threshold[context as usize] = value;
                } else if offset == 4 {
                    //self.claim[context as usize] = value as u32;

                    // Clear pending bit.
                    self.clear_pending(value);
                } else {
                    return Err(Exception::StoreAccessFault);
                }
            }
            _ => return Err(Exception::StoreAccessFault),
        }

        Ok(())
    }

    pub fn get_interrupt(&self) -> Option<u32> {
        if self.claim[1] != 0 {
            Some(self.claim[1])
        } else {
            None
        }
    }
}

impl Device for Plic {
    fn as_any(&self) -> &dyn std::any::Any {
        self
    }
    fn as_any_mut(&mut self) -> &mut dyn std::any::Any {
        self
    }
    fn load(&self, addr: MemorySize, size: Sizes) -> Result<MemorySize, Exception> {
        self.read(addr, size)
    }
    fn store(&mut self, addr: MemorySize, size: Sizes, value: MemorySize) -> Result<(), Exception> {
        self.write(addr, value, size)
    }
}
