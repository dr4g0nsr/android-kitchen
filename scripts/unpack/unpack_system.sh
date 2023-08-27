#!/bin/bash

clear

# Source variables from the "dumpvars.sh" script located in the "scripts" directory
source scripts/dumpvars.sh

echo "Unpacking system.dat.br/dat/img"

read -p "Please place the system.dat.br/dat/img file you want to unpack in the tool's root directory and press Enter" var

if [ -e "$LOCALDIR/system.new.dat.br" ]; then
	echo "Detected system.new.dat.br"
	"$bin/bin/brotli" -d "$LOCALDIR/system.new.dat.br"
	python "$bin/sdat2img.py" system.transfer.list system.new.dat system.img
	bash $unpack/unpackimg.sh system
	read -p "Unpacking completed" var
elif [ -e "$LOCALDIR/system.new.dat" ]; then
	echo "Detected system.new.dat"
    python "$bin/sdat2img.py" system.transfer.list system.new.dat system.img
    bash $unpack/unpackimg.sh system
  	read -p "Unpacking completed" var
elif [ -e "$LOCALDIR/system.img" ]; then
	echo "Detected system.img"
    bash $unpack/unpackimg.sh system
 	read -p "Unpacking completed" var
else
	read -p "No files detected to unpack" var
fi

bash main.sh
