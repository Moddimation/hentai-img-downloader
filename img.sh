#!/bin/bash

# Check if a file path is provided as a parameter
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file> <output path>"
    exit 1
fi
if [ $# -eq 1 ]; then
    echo "Usage: $0 <file> <output path>"
    exit 1
fi

# Check if the provided file exists
if [ ! -f "$1" ]; then
    echo "File not found: $1"
    exit 1
fi

folderName=$2

# Define an array of user agents
user_agents=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"
    # Add more user agents here
)

# Function to download and process images
download_images() {
    local line="$1"

    # Extract the image link from the line
    local link=$(echo "$line" | grep -o 'https://[^"]*')

    # Check if link contains "hentai-img" and "upload"
    if [[ $link == *"hentai-img"* && $link == *"upload"* ]]; then
        # Strip /p=X/ part from the URL
        link=$(echo "$link" | sed 's,/p=[0-9]\+,,g')
        # Check if file already exists
        local filename=$(basename "$link")

        # Download the image and check if it needs to be overwritten
        success=false
        # Check if the current link contains "pinterest", if so, terminate the loop
        if [[ "$line" == *"pinterest"* ]]; then
            echo "Found end of image tree. Terminating image processing."
            echo " "
            exit 0
        fi
        for agent in "${user_agents[@]}"; do
            echo " -"
            echo "Fetching link: $link"
            echo "Downloading image: $filename..."
            if wget --user-agent="$agent" -O "$folderName/$filename.tmp" "$link" >/dev/null 2>&1; then
                # Get the size of the downloaded file
                local downloaded_size=$(wc -c <"$folderName/$filename.tmp")
                # Get the size of the existing file if it exists
                local existing_size=0
                if [ -f "$folderName/$filename" ]; then
                    existing_size=$(wc -c <"$folderName/$filename")
                fi
                # If the downloaded file is larger or the existing file doesn't exist, overwrite it
                if [ "$downloaded_size" -gt "$existing_size" ]; then
                    echo "Saved to directory."
                    mv "$folderName/$filename.tmp" "$folderName/$filename"
                    success=true
                    break
                else
                    echo "No update, skipping"
                    rm "$folderName/$filename.tmp" >/dev/null 2>&1
                    success=true
                    break
                fi
            
            fi
            echo "Changing user agent"
        done
        if ! $success; then
            echo "Failed to download image from: $link"
        fi
    fi
}

# Loop through each line in the file and download the images
while IFS= read -r line; do
    download_images "$line"
done < "$1"

echo "Done"
echo " "
