#!/bin/zsh

if [ $(id -u) -ne 0 ]
then
    echo "Root permissions required: run 'sudo ./install.sh'"
    exit 1
fi

swift build -c release &&
sudo rm /usr/local/bin/printds 2>/dev/null
sudo cp .build/release/printds /usr/local/bin/printds &&
rm -rf .build

echo "Installation is complete."
echo "See 'printds --help' for more details."
