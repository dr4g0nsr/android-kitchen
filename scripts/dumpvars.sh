#!/bin/bash

SCRIPT_SOURCE=${BASH_SOURCE:-$0}
DIR_PATH=$(dirname $SCRIPT_SOURCE)
REALPATH=`realpath  $DIR_PATH/..`

if [[ -z "$REALPATH" ]]; then
    echo "No path"
    exit 1
fi

IMAGES="$REALPATH/images"
UNPACKS="$REALPATH/unpacks"
LOCALDIR="$REALPATH"
HOST="$(uname)"
tmpdir="$REALPATH/tmp"
bin="$REALPATH/tools"
script="$REALPATH/scripts"
unpack="$script/unpack"
pack="$script/pack"
day=$(date "+%Y%m%d")

#echo "Root dir found: $REALPATH"
