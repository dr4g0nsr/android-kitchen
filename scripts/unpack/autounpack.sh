#!/bin/bash

clear

# Source variables from the "dumpvars.sh" script located in the "scripts" directory
source scripts/dumpvars.sh

echo "Automatically Extracting system/vendor/boot from ROM"

# List all zip files in the current directory and store them in an array
zip_files=($(ls $IMAGES/*.zip 2>/dev/null))

# Check the number of zip files found
num_zips=${#zip_files[@]}

if [ "$num_zips" -eq 0 ]; then
    echo "No zip files found in the images directory."
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

selected_zip_name=`basename $selected_zip`
selected_zip_full_path="$UNPACKS/$selected_zip_name"

if [[ -d "$selected_zip_full_path" ]]; then
	echo "Path already exist, deleting"
	rm -rf "$selected_zip_full_path"
fi

unpack_files() {
	mkdir "$selected_zip_full_path"
	# Extract the chosen zip file
	unzip "$selected_zip" -d $selected_zip_full_path
	if [[ $? -gt 0 ]]; then
		echo "Unzip failed"
		read -p "Press enter" var
		exit 1
	fi
}

boot_extract() {
	if [[ -d "$selected_zip_full_path/boot" ]]; then
		rm -rf $selected_zip_full_path/boot
	fi
	mkdir $selected_zip_full_path/boot
	if [ -e $selected_zip_full_path/boot.img ]; then
		$bin/AIK/unpackimg.sh $selected_zip_full_path/boot.img
		if [[ $? -gt 0 ]]; then
			echo "Error: unpackimg.sh failed"
			read -p "Press enter" var
			exit 1
		fi
		mv $bin/AIK/ramdisk $selected_zip_full_path/boot/
		if [[ $? -gt 0 ]]; then
			echo "Error: ramdisk failed"
			read -p "Press enter" var
			exit 1
		fi
		mv $bin/AIK/split_img $selected_zip_full_path/boot/
		if [[ $? -gt 0 ]]; then
			echo "Error: split_img failed"
			read -p "Press enter" var
			exit 1
		fi
		cd $REALPATH
	fi
}

system_extract(){
	if [ -e "$selected_zip_full_path/system.new.dat.br" ]; then
		echo "Detected system.new.dat.br"
		"$bin/bin/brotli" -d "$selected_zip_full_path/system.new.dat.br"
		if [[ $? -gt 0 ]]; then
			echo "brotli unpack failed"
			read -p "Press enter" var
			exit 1
		fi
		python "$bin/sdat2img.py" $selected_zip_full_path/system.transfer.list $selected_zip_full_path/system.new.dat $selected_zip_full_path/system.img
		if [[ $? -gt 0 ]]; then
			echo "sdat2img.py failed"
			read -p "Press enter" var
			exit 1
		fi
		bash $unpack/unpackimg.sh system $selected_zip_full_path
		if [[ $? -gt 0 ]]; then
			echo "unpackimg.sh system failed"
			read -p "Press enter" var
			exit 1
		fi
	elif [ -e "$selected_zip_full_path/system.new.dat" ]; then
		echo "Detected system.new.dat"
		python "$bin/sdat2img.py" $selected_zip_full_path/system.transfer.list $selected_zip_full_path/system.new.dat $selected_zip_full_path/system.img
		if [[ $? -gt 0 ]]; then
			echo "sdat2img.py failed"
			read -p "Press enter" var
			exit 1
		fi
		bash $unpack/unpackimg.sh system $selected_zip_full_path
		if [[ $? -gt 0 ]]; then
			echo "unpackimg.sh system failed"
			read -p "Press enter" var
			exit 1
		fi
	elif [ -e "$selected_zip_full_path/system.img" ]; then
		echo "Detected system.img"
		bash $unpack/unpackimg.sh system $selected_zip_full_path
		if [[ $? -gt 0 ]]; then
			echo "unpackimg.sh system failed"
			read -p "Press enter" var
			exit 1
		fi
	fi
}

vendor_extract(){
	if [ -e "$selected_zip_full_path/vendor.new.dat.br" ]; then
		echo "Detected vendor.new.dat.br"
		"$bin/bin/brotli" -d "$selected_zip_full_path/vendor.new.dat.br"
		python "$bin/sdat2img.py" vendor.transfer.list vendor.new.dat vendor.img
		bash $unpack/unpackimg.sh vendor
	elif [ -e "$selected_zip_full_path/vendor.new.dat" ]; then
		echo "Detected vendor.new.dat"
		python "$bin/sdat2img.py" vendor.transfer.list vendor.new.dat vendor.img
		bash $unpack/unpackimg.sh vendor
	elif [ -e "$selected_zip_full_path/vendor.img" ]; then
		echo "Detected vendor.img"
		bash $unpack/unpackimg.sh vendor
	fi
}

unpack_files
boot_extract
system_extract
#vendor_extract

read -p "Extraction complete, press enter" var

bash main.sh
