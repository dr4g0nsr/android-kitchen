#!/bin/bash

clear

# Source variables from the "dumpvars.sh" script located in the "scripts" directory
source scripts/dumpvars.sh

echo "Automatically Extracting system/vendor/boot from ROM"

# List all zip files in the current directory and store them in an array
zip_files=($(ls *.zip 2>/dev/null))

# Check the number of zip files found
num_zips=${#zip_files[@]}

if [ "$num_zips" -eq 0 ]; then
    echo "No zip files found in the current directory."
    exit
elif [ "$num_zips" -eq 1 ]; then
    selected_zip="${zip_files[0]}"
    echo "Using the found zip file: $selected_zip"
else
    echo "Multiple zip files found:"
    for ((i = 0; i < num_zips; i++)); do
        echo "[$i] ${zip_files[$i]}"
    done
    read -p "Enter the number of the zip file to use: " zip_choice
    if [ "$zip_choice" -ge 0 ] && [ "$zip_choice" -lt "$num_zips" ]; then
        selected_zip="${zip_files[$zip_choice]}"
        echo "Using the selected zip file: $selected_zip"
    else
        echo "Invalid choice. Exiting."
        exit
    fi
fi

# Extract the chosen zip file
unzip $selected_zip system* boot* vendor/*
boot_extract
system_extract
vendor_extract
echo "Extraction complete, press enter"

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

bash main.sh
