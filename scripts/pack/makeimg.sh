#!/bin/bash

# Source variables from the "dumpvars.sh" script located in the parent directory
source ../dumpvars.sh

# Get the current directory and change to it
LOCALDIR=`cd "$( dirname $0 )" && pwd`
cd $LOCALDIR

echo ""
read -p "Please enter the name of the partition to package (without .img extension): " species

echo "
Start packaging

Current image size:

_________________

`du -sh ./out/$species | awk '{print $1}'`

`du -sm ./out/$species | awk '{print $1}' | sed 's/$/&M/'`

`du -sb ./out/$species | awk '{print $1}' | sed 's/$/&B/'`
_________________

When packaging using G as unit, you must provide the unit and it should be an integer.
When packaging using B as unit, you don't need to provide the unit, and a certain size will be added to the automatically detected size.
It's recommended to use M as unit for packaging. You need to provide the unit and add at least 130M to the automatically detected size.
"

read -p "Please enter the value for packaging: " size

M="$(echo "$size" | sed 's/M//g')"
G="$(echo "$size" | sed 's/G//g')"

if [ $(echo "$size" | grep 'M') ]; then
 ssize=$(($M*1024*1024))
elif [ $(echo "$size" | grep 'G') ]; then
 ssize=$(($G*1024*1024*1024))
else
 ssize=$size
fi

if [ $species = "system" ]; then
 $bin/mkuserimg_mke2fs.sh ./out/$species/$species ./out/$species'.img' ext4 /$species $ssize -j '0' -T '1230768000' -C ./out/config/$species'_fs_config' -L $species ./out/config/$species'_file_contexts' 2> ./out/error.log
else
 $bin/mkuserimg_mke2fs.sh ./out/$species/ ./out/$species'.img' ext4 /$species $ssize -j '0' -T '1230768000' -C ./out/config/$species'_fs_config' -L $species ./out/config/$species'_file_contexts' 2> ./out/error.log 
fi
sed -i '1d' ./out/error.log

if [ -s ./out/error.log ]; then
 echo "Packaging failed, please check the error log in the 'out' directory"
else
 echo "Packaging complete"
 rm -rf ./out/error.log
 echo "Output to the SGSI folder"
fi

if [ -e ./SGSI ]; then
 rm -rf ./SGSI
 mkdir ./SGSI
else
 mkdir ./SGSI
fi

if [ -e ./SGSI ]; then
 mv ./out/$species'.img' ./SGSI
 cp -r ./刷机教程.txt ./SGSI
 # Check for the zip containing deleted apps
 if [ -e ./out/delete.zip ]; then
   mv ./out/delete.zip ./SGSI
 fi
fi
