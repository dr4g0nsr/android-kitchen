#!/bin/bash

clear

# Source variables from the "dumpvars.sh" script located in the "scripts" directory
source ../dumpvars.sh

echo "Unpacking super.img dynamic partition image"

read -p "Please place the super.img you want to unpack in the tool's root directory and press Enter" var

# Remove any existing "super" directory and create a new one
rm -rf $LOCALDIR/super
mkdir $LOCALDIR/super

# Use the "file" command to identify the type of the super.img file
file $(find -type f -name 'super.img') > $LOCALDIR/file.txt

echo "Identified $(find ./ -type f -name 'super.img')"

if [ $(grep -o 'sparse' ./file.txt) ]; then
	echo "Current super.img is in sparse format, converting to rimg..."
	$bin/bin/simg2img $(find ./ -type f -name 'super.img') $LOCALDIR/superr.img
	echo "Conversion completed"
	echo "Unpacking super.img..."
	$bin/bin/lpunpack $LOCALDIR/superr.img $LOCALDIR/super
 	rm -rf $LOCALDIR/superr.img
 	read -p "Unpacking completed" var
elif [ $(grep -o 'data' $LOCALDIR/file.txt) ]; then
 	echo "Unpacking super.img..."
 	$bin/bin/lpunpack $(find ./ -type f -name 'super.img') ./super
 	rm -rf $LOCALDIR/super.img
 	read -p "Unpacking completed" var
else
	read -p "No super.img file to unpack detected" var
fi

rm -rf $LOCALDIR/file.txt

bash main.sh
