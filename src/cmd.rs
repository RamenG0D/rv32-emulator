use std::path::PathBuf;
use structopt::StructOpt;

#[derive(StructOpt)]
#[structopt(
    name = "rv32-emulator",
    author = "RamenG0D",
    about = "a simple riscv 32 bit emulator written in rust :D",
	setting = structopt::clap::AppSettings::ColoredHelp
)]
pub struct VmArgs {
    /// Prints debug information to the console about the vm state
    #[structopt(short, long)]
    pub debug: bool,

    #[structopt(subcommand)]
    pub cmd: VmCmd,

    /// Output file, stdout if not present
    #[structopt(parse(from_os_str), short, long)]
    pub output: Option<PathBuf>,
}

#[derive(StructOpt)]
pub enum VmCmd {
    #[structopt(
		about = "Run a binary file",
		setting = structopt::clap::AppSettings::ColoredHelp
	)]
    Run {
        /// Input files
        #[structopt(parse(from_os_str))]
        bin_file: PathBuf,
        #[structopt(parse(from_os_str))]
        disk_file: Option<PathBuf>,

        /// Step through the program by asking for usr input after each instruction
        #[structopt(short, long)]
        step: bool,
    },
    #[structopt(
		about = "Generates completions for the current shell and write them to stdout",
		setting = structopt::clap::AppSettings::ColoredHelp
	)]
    Completions {},
    /*
    #[structopt(about = "Run an ELF file")]
    Elf {},
    #[structopt(about = "Run an assembly file")]
    Asm {},
    */
}
