#!/bin/bash

REALPATH=`realpath ./..`

LOCALDIR="$REALPATH"
HOST="$(uname)"
tmpdir="$REALPATH/tmp"
bin="$REALPATH/tools"
script="$REALPATH/script"
unpack="$script/unpack"
pack="$script/pack"
day=$(date "+%Y%m%d")

echo "Root dir found: $REALPATH"
