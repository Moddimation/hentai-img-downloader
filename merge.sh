#!/bin/bash

echo "Creating the 'dist' directory if it doesn't exist"
mkdir -p dist

# Loop through every folder starting with "images."
for dir in images*; do
    echo "Processing files in directory: $dir"
    echo
    echo "Traverse all directories and rename/move files"
    cd "$dir" || exit

    # Process image and video files
    shopt -s nullglob
    for file in *.jpg *.jpeg *.png *.gif *.bmp *.mp4; do
        echo "Processing file: $file"
        oldName=$(basename "$file")
        extension="${oldName##*.}"
        randomWord=$(LC_ALL=C tr -dc '[:alnum:]' < /dev/urandom | head -c8)
        newName="$randomWord.$extension"

        echo "Renaming and moving file: $oldName to $newName"
        mv "$file" "../dist/$newName"
    done
    shopt -u nullglob

    cd ..

    echo
    echo "Checking directory contents..."

    # Check if the directory only contains .tmp and .html files
    fileCount=$(find "$dir" -maxdepth 1 -type f | wc -l)
    if [[ $fileCount -eq 0 ]]; then
        echo "Deleting empty directory: $dir"
        rm -r "$dir"
    else
        echo "Notice: Directory $dir contains files other than .tmp and .html files."
    fi

    echo
done

exit 0
