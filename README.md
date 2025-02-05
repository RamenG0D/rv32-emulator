
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

this just adds the completions file to the proper location

### you can still just `cargo install` you just dont get any completions

## uninstall

to uninstall

```sh
cargo uninstall rv32
```

this removes the bin and completions

# How to run programs?

TODO: write docs

# Can it run a kernel?

not quite yet but xv6-riscv32 is a work in progress (and linux kernel)

# Star it

please!
