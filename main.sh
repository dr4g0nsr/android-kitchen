#!/bin/bash

clear

# Source variables from the "dumpvars.sh" script located in the "scripts" directory
source scripts/dumpvars.sh

# Check for dependencies: dialog and zip
command -v dialog >/dev/null 2>&1 || { echo >&2 "Dialog is required but it's not installed. Aborting."; exit 1; }
command -v zip >/dev/null 2>&1 || { echo >&2 "Zip is required but it's not installed. Aborting."; exit 1; }

while true; do
    # Show the menu using dialog
    choice=$(dialog --clear --title "Android Kitchen 20230824" \
                    --menu "Please select an option:" 22 50 15 \
                    1 "Auto Unpack" \
                    2 "Unpack system" \
                    3 "Unpack vendor" \
                    4 "Unpack boot.img" \
                    5 "Unpack super.img dynamic partition image" \
                    6 "Auto Pack" \
                    7 "Pack system" \
                    8 "Pack vendor" \
                    9 "Pack boot.img" \
                    10 "Pack super.img dynamic partition image" \
                    11 "Embed system/vendor.img into super.img" \
                    12 "Generate updater script" \
                    13 "Estimate system/vendor sizes" \
                    14 "Decrypt OPPO OZIP" \
                    0 "Exit" 3>&1 1>&2 2>&3)

    case $choice in
        1) bash $unpack/autounpack.sh && sleep 1 ;;
        2) bash ./scripts/unpack/unpack_system.sh ;;
        3) bash ./scripts/unpack/unpack_vendor.sh ;;
        4) bash ./scripts/unpack/unpack_boot.sh ;;
        5) bash ./scripts/unpack/unpack_super.sh ;;
        6) bash ./scripts/pack/autopack.sh ;;
        7) bash ./scripts/pack/pack_system.sh ;;
        8) bash ./scripts/pack/pack_vendor.sh ;;
        9) bash ./scripts/pack/pack_boot.sh ;;
        10) bash ./scripts/pack/pack_super.sh ;;
        11) bash ./scripts/embed/embed_images.sh ;;
        12) bash ./scripts/generate/generate_updater.sh ;;
        13) bash ./scripts/estimate/estimate_size.sh ;;
        14) bash ./scripts/decrypt/decrypt_ozip.sh ;;
        0) exit ;;
        *) echo "Invalid choice"; sleep 1 ;;
    esac
done
