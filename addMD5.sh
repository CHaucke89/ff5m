#!/bin/bash

##
## Adding MD5 checksum to gcode file
##
## Copyright (C) 2025, Alexander K <https://github.com/drA1ex>
##
## This file may be distributed under the terms of the GNU GPLv3 license

if [ $# -ne 1 ]; then echo "Usage: $0 your_file.gcode"; exit 1; fi
if ! [ -f "$1" ]; then echo "File $1 not found"; exit 1; fi

# Find md5 util and calculate the MD5 hash of the file
if which md5 &> /dev/null; then
    hash=$(md5 -q "$1" | awk '{print $1}')
elif which md5sum &> /dev/null; then
    hash=$(md5sum "$1" | awk '{print $1}')
else
    echo "md5 util missing. Supported md5 or md5sum"
    exit 2
fi

# Define prefix
prefix="; MD5:"

# Construct the payload
payload="${prefix}${hash}"

# Create a temporary file and append the original file content
tempfile=$(mktemp)
echo "$payload" > "$tempfile"
cat "$1" >> "$tempfile"

# Move the temp file to the original file location
mv "$tempfile" "$1"
