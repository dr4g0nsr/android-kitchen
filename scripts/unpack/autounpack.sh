#!/bin/bash

clear 

# Source variables from the "dumpvars.sh" script located in the "scripts" directory
source scripts/dumpvars.sh

echo "Automatically Extracting system/vendor/boot from ROM"

read -p "Please rename the ROM you want to extract as update.zip, place it in the tool's root directory, and press Enter" var

boot_extract(){
	rm -rf $LOCALDIR/boot
	mkdir $LOCALDIR/boot
	if [ -e $LOCALDIR/boot.img ]; then
		cp -frp $LOCALDIR/boot.img $bin/AIK/
		cd $bin/AIK
		./unpackimg.sh ./boot.img
		mv ./ramdisk $LOCALDIR/boot/
		mv ./split_img $LOCALDIR/boot/
		cd $LOCALDIR
	fi
}

system_extract(){
	if [ -e "$LOCALDIR/system.new.dat.br" ]; then
		echo "Detected system.new.dat.br"
		"$bin/bin/brotli" -d "$LOCALDIR/system.new.dat.br"
		python "$bin/sdat2img.py" system.transfer.list system.new.dat system.img
		bash $unpack/unpackimg.sh system
	elif [ -e "$LOCALDIR/system.new.dat" ]; then
		echo "Detected system.new.dat"
		python "$bin/sdat2img.py" system.transfer.list system.new.dat system.img
		bash $unpack/unpackimg.sh system
	elif [ -e "$LOCALDIR/system.img" ]; then
		echo "Detected system.img"
		bash $unpack/unpackimg.sh system
	fi
}

vendor_extract(){
	if [ -e "$LOCALDIR/vendor.new.dat.br" ]; then
		echo "Detected vendor.new.dat.br"
		"$bin/bin/brotli" -d "$LOCALDIR/vendor.new.dat.br"
		python "$bin/sdat2img.py" vendor.transfer.list vendor.new.dat vendor.img
		bash $unpack/unpackimg.sh vendor
	elif [ -e "$LOCALDIR/vendor.new.dat" ]; then
		echo "Detected vendor.new.dat"
		python "$bin/sdat2img.py" vendor.transfer.list vendor.new.dat vendor.img
		bash $unpack/unpackimg.sh vendor
	elif [ -e "$LOCALDIR/vendor.img" ]; then
		echo "Detected vendor.img"
		bash $unpack/unpackimg.sh vendor
	fi
}

if [ -e update.zip ]; then
	echo "Detected update.zip"
	unzip $LOCALDIR/update.zip system* vendor* boot*
	boot_extract
	system_extract
	vendor_extract
	echo "Extraction complete"
else
	read -p "No update.zip to extract detected" var
fi

bash main.sh
