#!/bin/bash

clear

echo "Android Kitchen 20230824"
echo ""
echo "Please place the system/vendor/boot/update.zip files to be unpacked in the root directory of this tool."
echo ""
echo "I. Unpacking"
echo "1. Auto Unpack (Place the OTA update package named update.zip in this tool's root directory, it will automatically unpack boot/system/vendor partitions.)"
echo "2. Unpack system (including img/dat/dat.br files)"
echo "3. Unpack vendor (including img/dat/dat.br files)"
echo "4. Unpack boot.img"
echo "5. Unpack super.img dynamic partition image"
echo ""
echo "II. Packing"
echo "6. Auto Pack (Automatically create an OTA update package for system/vendor/boot partitions)"
echo "7. Pack system (supports img/dat/dat.br files)"
echo "8. Pack vendor (supports img/dat/dat.br files)"
echo "9. Pack boot.img"
echo "10. Pack super.img dynamic partition image"
echo ""
echo "III. Other"
echo "11. Embed system/vendor.img into super.img"
echo "12. Generate updater script for OTA update package"
echo "13. Estimate system/vendor sizes"
echo "14. Decrypt OPPO OZIP packages"
echo ""
echo "0. Exit program"

read -p "Please enter your choice: " c

if [ "$c" == "0" ]; then
    exit
elif [ "$c" == "1" ]; then
	bash ./scripts/unpack/autounpack.sh
elif [ "$c" == "2" ]; then
	bash ./scripts/unpack/unpack_system.sh
elif [ "$c" == "3" ]; then
	bash ./scripts/unpack/unpack_vendor.sh
elif [ "$c" == "4" ]; then
	bash ./scripts/unpack/unpack_boot.sh
elif [ "$c" == "5" ]; then
	bash ./scripts/unpack/unpack_super.sh
elif [ "$c" == "6" ]; then 
    echo "Automatic packaging in progress..."
    # Assuming you have a script named "autopack.sh" for automatic packaging
    bash ./scripts/pack/autopack.sh
elif [ "$c" == "7" ]; then 
    echo "Packaging system in progress..."
    # Assuming you have a script named "pack_system.sh" for packaging system
    bash ./scripts/pack/pack_system.sh
elif [ "$c" == "8" ]; then 
    echo "Packaging vendor in progress..."
    # Assuming you have a script named "pack_vendor.sh" for packaging vendor
    bash ./scripts/pack/pack_vendor.sh
elif [ "$c" == "9" ]; then 
    echo "Packaging boot.img in progress..."
    # Assuming you have a script named "pack_boot.sh" for packaging boot.img
    bash ./scripts/pack/pack_boot.sh
elif [ "$c" == "10" ]; then 
    echo "Packaging super.img dynamic partition image in progress..."
    # Assuming you have a script named "pack_super.sh" for packaging super.img
    bash ./scripts/pack/pack_super.sh
elif [ "$c" == "11" ]; then 
    echo "Embedding system/vendor.img into super.img in progress..."
    # Assuming you have a script named "embed_images.sh" for embedding images
    bash ./scripts/embed/embed_images.sh
elif [ "$c" == "12" ]; then 
    echo "Generating updater script for flashable package in progress..."
    # Assuming you have a script named "generate_updater.sh" for generating updater script
    bash ./scripts/generate/generate_updater.sh
elif [ "$c" == "13" ]; then 
    echo "Estimating system/vendor size in progress..."
    # Assuming you have a script named "estimate_size.sh" for estimating sizes
    bash ./scripts/estimate/estimate_size.sh
elif [ "$c" == "14" ]; then 
    echo "Decrypting OPPO OZIP in progress..."
    # Assuming you have a script named "decrypt_ozip.sh" for decrypting OZIP
    bash ./scripts/decrypt/decrypt_ozip.sh
else
    echo "Command does not exist"
fi 
