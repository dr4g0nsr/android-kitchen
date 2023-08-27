#!/bin/bash

clear

# Source variables from the "dumpvars.sh" script located in the "scripts" directory
source scripts/dumpvars.sh

echo "Unpacking boot.img"

read -p "Please place the boot.img you want to unpack in the tool's root directory and press Enter" var

# Remove any existing "boot" directory and create a new one
rm -rf $LOCALDIR/boot
mkdir $LOCALDIR/boot

if [ -e $LOCALDIR/boot.img ]; then
	# Copy the boot.img to the AIK (Android Image Kitchen) directory
	cp -frp $LOCALDIR/boot.img $bin/AIK/
	cd $bin/AIK
	# Unpack the boot.img using the "unpackimg.sh" script
	./unpackimg.sh ./boot.img
	mv ./ramdisk $LOCALDIR/boot/
	mv ./split_img $LOCALDIR/boot/
	cd $LOCALDIR
else
	read -p "No boot.img file to unpack detected" var
fi

bash main.sh
