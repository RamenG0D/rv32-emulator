
use clap::{Parser, Subcommand};
use std::path::PathBuf;

#[derive(Parser, Debug, PartialEq)]
#[command(version, about, long_about = None)]
#[command(propagate_version = true)]
pub enum ProgramCommands {
    #[command(name = "run", subcommand)]
    RunCmd(RunCommand)
}

#[derive(Subcommand, Debug, PartialEq)]
#[command(name = "run", about, long_about = None)]
pub enum RunCommand {
    Bin(RunBinCmd),
    Asm,
    Input,
}

#[derive(Parser, Debug, PartialEq)]
#[command(about, long_about = None)]
pub struct RunBinCmd {
    #[arg(short, long)]
    pub bin_file: PathBuf,
    #[arg(long)]
    pub disk: Option<PathBuf>,
    #[arg(short, long)]
    pub debug: bool,
}
