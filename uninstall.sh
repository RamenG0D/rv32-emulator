#!/bin/bash

TYPE="bash"

if [ "$1" != "" ]; then
    TYPE="$1"
fi

# uninstall actual program
cargo uninstall

# remove the completion script
case $TYPE in
    "bash")
        sudo rm -f /usr/share/bash-completion/completions/rv32-emulator
        ;;
    "zsh")
        sudo rm -f /usr/share/zsh/site-functions/_rv32-emulator
        ;;
    *)
        echo "Unknown shell type: $TYPE"
        ;;
esac
