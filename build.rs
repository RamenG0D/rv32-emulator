
use clap::CommandFactory;
use clap_complete::{generate_to, shells::Zsh};
use std::io::Error;

include!("src/arg_parser.rs");

const BIN_NAME: &str = "rv32-emulator";

fn main() -> Result<(), Error> {
    const COMPLETIONS_DIR: &str = "completions";
    if let Ok(dir) = std::fs::read_dir(COMPLETIONS_DIR) {
        if dir.count() > 0 {
            std::fs::remove_dir_all(COMPLETIONS_DIR)?;
        }
    }
    std::fs::create_dir(COMPLETIONS_DIR)?;

    let mut cmd = ProgramCommands::command();

    let path = generate_to(
        Zsh,
        &mut cmd, // We need to specify what generator to use
        BIN_NAME,  // We need to specify the bin name manually
        COMPLETIONS_DIR,   // We need to specify where to write to
    )?;

    println!("cargo:warning=completion file is generated: {path:?}");

    Ok(())
}
