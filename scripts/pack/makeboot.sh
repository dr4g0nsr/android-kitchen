#!/bin/bash

# Source variables from the "dumpvars.sh" script located in the parent directory
source ../dumpvars.sh

echo "Generating new-boot.img..."
# Move files from the "./boot/" directory to the specified location in the "bin/AIK" directory
mv ./boot/* $bin/AIK/
cd $bin/AIK
# Repack the image using the "repackimg.sh" script with the "--forceelf" option
./repackimg.sh --forceelf
# Rename the generated "image-new.img" to "boot-new.img"
mv ./image-new.img ./boot-new.img
# Move the "boot-new.img" to the "./boot/" directory
mv ./boot-new.img ../../boot/
# Remove temporary directories and files
rm -rf ./split_img
rm -rf ./ramdisk
rm -rf ./boot.img
# Check if "ramdisk-new.cpio.gz" exists and remove it if it does
if [ -e $(pwd)/ramdisk-new.cpio.gz ]; then
 rm -rf $(pwd)/ramdisk-new.cpio.gz
fi
echo "Generation complete, output to the boot directory"
