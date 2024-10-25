#!/bin/bash

TYPE="bash"

if [ "$1" != "" ]; then
    echo "Setting shell type to $1"
    TYPE="$1"
fi
echo "Shell type is $TYPE"

echo "Installing rv32-emulator"
cargo install --path .
echo "Installed rv32-emulator"

# now we copy the completion script to the right place
echo "Installing completion script for $TYPE"
case $TYPE in
    "bash")
        sudo cp ./completions/rv32-emulator.bash /usr/share/bash-completion/completions/rv32-emulator
        ;;
    "zsh")
        sudo cp ./completions/_rv32-emulator /usr/share/zsh/site-functions/_rv32-emulator
        ;;
    *)
        echo "Unknown shell type: $TYPE"
        ;;
esac
echo "Installed completion script for $TYPE"
