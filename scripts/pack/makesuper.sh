#!/bin/bash

# Source variables from the "dumpvars.sh" script located in the parent directory
source ../dumpvars.sh

echo "

Start Packaging

Make sure all the img files you want to package are in the tool's root directory and named as rimg (must follow this convention).

Currently supported partitions for super.img packaging: system vendor product odm

The size of the super partition should be the total size of the rimg files you want to package + 1G (at least +1G to avoid potential errors).

The actual usable size of the super partition will be equal to the total size of the rimg files you want to package.

When packaging data using G as the unit, it should be a whole number.

If the packaging data is not a whole number, use M as the unit.

When using B as the unit, you don't need to include the unit.
"

if [ -e ./system.img ]; then
 mv ./system.img ./bin/build_super/
fi
 
if [ -e ./vendor.img ]; then
 mv ./vendor.img ./bin/build_super/
fi

if [ -e ./product.img ]; then
 mv ./product.img ./bin/build_super/
fi

if [ -e ./odm.img ]; then
 mv ./odm.img ./bin/build_super/
fi

cd ./bin/build_super
cat ./misc_into.txt >> ./build_super.txt

read -p "Please enter the partitions you want to package (separated by spaces): " partition
read -p "Please enter the size of the super partition: " supersize

superM="$(echo "$supersize" | sed 's/M//g')"
superG="$(echo "$supersize" | sed 's/G//g')"

if [ $(echo "$supersize" | grep 'M') ]; then
 superssize="$(($superM*1024*1024))"
elif [ $(echo "$supersize" | grep 'G') ]; then
 superssize="$(($superG*1024*1024*1024))"
else
 superssize="$supersize"
fi

read -p "Please enter the actual usable size of the super partition: " size

sizeM="$(echo "$size" | sed 's/M//g')"
sizeG="$(echo "$size" | sed 's/G//g')"

if [ $(echo "$size" | grep 'M') ]; then
 ssize="$(($sizeM*1024*1024))"
elif [ $(echo "$size" | grep 'G') ]; then
 ssize="$(($sizeG*1024*1024*1024))"
else
 ssize="$size"
fi

echo "dynamic_partition_list=$partition
super_main_partition_list=$partition
super_super_device_size=$superssize
super_main_group_size=$ssize
" >> ./build_super.txt
echo "Super.img generation information integrated, generating super.img..."
python3 ./build_super_image.py ./build_super.txt ./super.img
rm -rf ./build_super.txt
echo "super.img has been generated and output to the super directory"
cd ../../
rm -rf ./super
mkdir ./super
mv ./bin/build_super/*img ./
mv ./super.img ./super/
