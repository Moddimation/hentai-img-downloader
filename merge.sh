#!/bin/bash

echo "Creating the \"dist\" directory if it doesn't exist"
mkdir -p "dist"

# Loop through every folder starting with "images."
for dir in images.*; do
    echo "Processing files in directory: $dir"
    echo

    echo "Traverse all directories and rename/move files"
    pushd "$dir" >/dev/null || exit 1

    for file in $(find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.mp4" \)); do
        echo "Processing file: $file"
        oldName=$(basename "$file")
        extension="${oldName##*.}"
        randomWord=$(head /dev/urandom | tr -dc '0123456789' | fold -w 8 | head -n 1)
        newName="$randomWord.$extension"

        echo "Renaming and moving file: $oldName to $newName"
        mv "$file" "../dist/$newName"
    done

    popd >/dev/null || exit 1

    echo
    echo "Checking directory contents..."

    # Check if the directory only contains .tmp and .html files
    fileCount=$(find "$dir" -type f | wc -l)
    notEmpty=false

    if [[ $fileCount -gt 0 ]]; then
        for file in "$dir"/*.*; do
            if [[ "${file##*.}" != "tmp" && "${file##*.}" != "html" ]]; then
                notEmpty=true
                break
            fi
        done
    fi

    # Delete the directory if it only contains .tmp and .html files
    if ! $notEmpty; then
        if [[ $fileCount -eq 0 ]]; then
            echo "Deleting empty directory: $dir"
            rm -r "$dir"
        else
            echo "Notice: Directory $dir contains files other than .tmp and .html files."
        fi
    fi

    echo
done

exit 0
