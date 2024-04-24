#!/bin/bash

# Create the "dist" directory if it doesn't exist
mkdir -p "dist"

# Traverse all directories and rename/move files
find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.mp4" \) -exec sh -c '
    oldName=$(basename "$0")
    extension="${oldName##*.}"
    digits=0123456789

    isNumeric=true

    # Note: Checking if the filename contains any digits to determine whether to generate a random name
    for char in ${digits}; do
        if [[ ! "$oldName" == *$char* ]]; then
            isNumeric=false
            break
        fi
    done

    if [ "$isNumeric" = true ]; then
        randomWord=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
    else
        randomWord=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
    fi

    newName="$randomWord.$extension"

    echo "Renaming and moving file: $oldName to $newName"
    mv "$0" "dist/$newName"
' {} \;

# Delete empty subdirectories
find . -type d -empty -delete
