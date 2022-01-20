#!/bin/zsh

if [ $(id -u) -ne 0 ]
then
    echo "Root permissions required: run 'sudo sh install.sh'"
    exit 1
fi

swift build -c release &&
sudo rm /usr/local/bin/printds 2>/dev/null
sudo cp .build/release/printds /usr/local/bin/printds &&
rm -rf .build

echo "Installation is completed."
echo "Run 'printds --help' for more details."
