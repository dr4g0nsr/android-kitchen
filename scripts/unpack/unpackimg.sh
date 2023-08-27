#!/bin/bash

# Source variables from the "dumpvars.sh" script located in the "scripts" directory
source scripts/dumpvars.sh

# Change directory to the tool's root directory
cd "$2"

# Get the argument passed to the script (assuming it's a species identifier)
species="$1"

# Create a directory with the species identifier
mkdir ./"$species"

echo "Unpacking $species.img......."
# Run the imgextractor.py script with sudo to extract the specified image
sudo python3 $bin/imgextractor/imgextractor.py ./$species'.img' ./$species

# Remove the original species directory
rm -rf /"$species"
