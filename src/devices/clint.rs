use riscv_vm::{
    bus::{Device, VirtualDevice},
    csr::*,
    memory::{dram::Sizes, virtual_memory::MemorySize},
    trap::Exception,
};

pub const CLINT_BASE: u32 = 0x2000000;
pub const CLINT_END: u32 = CLINT_BASE + 0x10000;

/// The address that a msip register starts. A msip is a machine mode software interrupt pending
/// register, used to assert a software interrupt for a CPU.
pub const MSIP: u32 = 0; // (at CLINT_BASE but addr is already relative to CLINT_BASE)
/// The address that a msip register ends. `msip` is a 4-byte register.
pub const MSIP_END: u32 = MSIP + 0x4;

/// The address that a mtimecmp register starts. A mtimecmp is a memory mapped machine mode timer
/// compare register, used to trigger an interrupt when mtimecmp is greater than or equal to mtime.
pub const MTIMECMP: u32 = 0x4000;
/// The address that a mtimecmp register ends. `mtimecmp` is a 8-byte register.
pub const MTIMECMP_END: u32 = MTIMECMP + 0x8;

/// The address that a timer register starts. A mtime is a machine mode timer register which runs
/// at a constant frequency.
pub const MTIME: u32 = 0xbff8;
/// The address that a timer register ends. `mtime` is a 8-byte register.
pub const MTIME_END: u32 = MTIME + 0x8;

pub struct Clint {
    mtime: u64,
    mtimecmp: u64,
    msip: u64,
}

// static RT: std::sync::LazyLock<std::time::SystemTime> = std::sync::LazyLock::new(|| std::time::SystemTime::now());
// const FREQ_HZ: u128 = 1000000000;

impl Device for Clint {
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

impl Default for Clint {
    fn default() -> Self {
        Self::new()
    }
}

impl Clint {
    pub fn new() -> Self {
        Self {
            mtime: 0,
            mtimecmp: 0,
            msip: 0,
        }
    }

    pub fn new_device() -> VirtualDevice {
        VirtualDevice::new(Box::new(Self::new()), CLINT_BASE, CLINT_END)
    }

    /// Increment the mtimer register. It's not a real-time value. The MTIP bit (MIP, 7) is enabled
    /// when `mtime` is greater than or equal to `mtimecmp`.
    pub fn increment(&mut self, state: &mut CpuCsr) {
        self.mtime = self.mtime.wrapping_add(1);
        // Sync TIME csr.
        state.write(TIME, self.mtime as u32);

        // let now = std::time::SystemTime::now();
        // let diff_usecs = ((now.tv_sec - real_time_ref_secs) * 1000000) + (now.tv_usec - real_time_ref_usecs);
        // let diff_usecs = now.duration_since(*RT).unwrap().as_micros();
        // self.mtime = (diff_usecs * FREQ_HZ / 1000000) as u32;
        // self.mtime = (diff_usecs * FREQ_HZ / 1000000) as u64;

        if (self.msip & 1) != 0 {
            // Enable the MSIP bit (MIP, 3).
            state.write(MIP, state.read(MIP) | MSIP_BIT);
        }

        // 3.1.10 Machine Timer Registers (mtime and mtimecmp)
        // "The interrupt remains posted until mtimecmp becomes greater than mtime (typically as a
        // result of writing mtimecmp)."
        if self.mtimecmp > self.mtime {
            // Clear the MTIP bit (MIP, 7).
            state.write(MIP, state.read(MIP) & !MTIP_BIT);
        }

        // 3.1.10 Machine Timer Registers (mtime and mtimecmp)
        // "A timer interrupt becomes pending whenever mtime contains a value greater than or equal
        // to mtimecmp, treating the values as unsigned integers."
        if self.mtime >= self.mtimecmp {
            // Enable the MTIP bit (MIP, 7).
            state.write(MIP, state.read(MIP) | MTIP_BIT);
        }
    }

    pub fn read(&self, addr: u32, size: Sizes) -> Result<u32, Exception> {
        if !matches!(size, Sizes::Word) {
            return Err(Exception::LoadAccessFault);
        }
        match addr {
            MTIMECMP..MTIMECMP_END => Ok(self.mtimecmp as u32),
            MTIME..MTIME_END => Ok(self.mtime as u32),
            MSIP..MSIP_END => Ok(self.msip as u32),
            _ => Err(Exception::LoadAccessFault),
        }
    }

    pub fn write(&mut self, addr: u32, data: u32, size: Sizes) -> Result<(), Exception> {
        if !matches!(size, Sizes::Word) {
            return Err(Exception::StoreAccessFault);
        }
        match addr {
            MTIMECMP..MTIMECMP_END => {
                self.mtimecmp = data as u64;
                Ok(())
            }
            MTIME..MTIME_END => {
                self.mtime = data as u64;
                Ok(())
            }
            MSIP..MSIP_END => {
                self.msip = data as u64;
                Ok(())
            }
            _ => Err(Exception::StoreAccessFault),
        }
    }
}
