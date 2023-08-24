#!/bin/bash

clear

# Source variables from the "dumpvars.sh" script located in the "scripts" directory
source ../dumpvars.sh

echo "Unpacking vendor.dat.br/dat/img"

read -p "Please place the vendor.dat.br/dat/img file you want to unpack in the tool's root directory and press Enter" var

if [ -e "$LOCALDIR/vendor.new.dat.br" ]; then
	echo "Detected vendor.new.dat.br"
	"$bin/bin/brotli" -d "$LOCALDIR/vendor.new.dat.br"
	python "$bin/sdat2img.py" vendor.transfer.list vendor.new.dat vendor.img
	bash $unpack/unpackimg.sh vendor
 	read -p "Unpacking completed" var
elif [ -e "$LOCALDIR/vendor.new.dat" ]; then
	echo "Detected vendor.new.dat"
    python "$bin/sdat2img.py" vendor.transfer.list vendor.new.dat vendor.img
    bash $unpack/unpackimg.sh vendor
 	read -p "Unpacking completed" var
elif [ -e "$LOCALDIR/vendor.img" ]; then
	echo "Detected vendor.img"
    bash $unpack/unpackimg.sh vendor
 	read -p "Unpacking completed" var
else
	read -p "No files detected to unpack" var
fi

bash main.sh
