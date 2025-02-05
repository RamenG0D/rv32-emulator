
# The CLI application for running the `riscv-vm` backend

                        $$$$$$\   $$$$$$\  
                       $$ ___$$\ $$  __$$\ 
     $$$$$$\ $$\    $$\\_/   $$ |\__/  $$ |
    $$  __$$\\$$\  $$  | $$$$$ /  $$$$$$  |
    $$ |  \__|\$$\$$  /  \___$$\ $$  ____/ 
    $$ |       \$$$  / $$\   $$ |$$ |      
    $$ |        \$  /  \$$$$$$  |$$$$$$$$\ 
    \__|         \_/    \______/ \________|
                                           
                                           
                                           
                                      $$\            $$\                         
                                      $$ |           $$ |                        
     $$$$$$\  $$$$$$\$$$$\  $$\   $$\ $$ | $$$$$$\ $$$$$$\    $$$$$$\   $$$$$$\  
    $$  __$$\ $$  _$$  _$$\ $$ |  $$ |$$ | \____$$\\_$$  _|  $$  __$$\ $$  __$$\ 
    $$$$$$$$ |$$ / $$ / $$ |$$ |  $$ |$$ | $$$$$$$ | $$ |    $$ /  $$ |$$ |  \__|
    $$   ____|$$ | $$ | $$ |$$ |  $$ |$$ |$$  __$$ | $$ |$$\ $$ |  $$ |$$ |      
    \$$$$$$$\ $$ | $$ | $$ |\$$$$$$  |$$ |\$$$$$$$ | \$$$$  |\$$$$$$  |$$ |      
     \_______|\__| \__| \__| \______/ \__| \_______|  \____/  \______/ \__|      


## install

to install just run

```sh
cargo install --path .
```

to add completions to your shell, you need to add the output of this command to you shells
rc script or other start script

for zsh
```zsh
source <(rvemu completions)
```

### you can still just `cargo install` you just dont get any completions

## uninstall

just run

```sh
cargo uninstall rvemu
```

# How to run programs?

## first you'll need to compile the program

to compile a program you will need to install the [riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain) through your distro or building through source.
**if building from source then be sure you configure the build with**
```
--with-arch=rv32imazicsr --with-abi=ilp32
```
**so your configure command might look like**
```sh
./configure --prefix=/opt/riscv --with-arch=rv32imazicsr --with-abi=ilp32
```

Next you will need to compile your program. You can do this using the riscv toolchains gcc `riscv32-unknown-linux-gnu-gcc`
once compiled the program wil be in the ELF format which cannot yet be directly run.

so we can run this command
```sh
riscv32-unknown-linux-gnu-objcopy -O binary < program > < program >.bin
```
this basically removes all the extra stuff from the elf format leaving only the actually program binary
! **NOTE this can only run the program when you do not use std AND no floats (currently)** !

it can then be run with
```sh
rvemu run < program >.bin
```

TODO: write docs

# Can it run a kernel?

not quite yet but xv6-riscv32 is a work in progress (and the linux kernel)

# Star it

please!
