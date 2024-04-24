#!/bin/bash
echo " "
echo "Mochimatic Hentai Downloader"
echo " "

imageFolder="images"

# Prompt user for the website link
read -p "Enter the website link: " website_link

# Check if the provided link is valid
if [[ ! "$website_link" =~ ^https?:// ]]; then
    echo "Invalid website link: $website_link"
    exit 1
fi

# Function to create the directory for downloaded images
directoryCreate() {
    local download_dir="images"
    
    # Check if the download directory already exists
    if [ -d "$download_dir" ]; then
        local i=1
        while [ -d "$imageFolder" ]; do
            imageFolder="${download_dir}.$i"
            ((i++))
        done
    fi

    # Create the new download directory
    mkdir -p "$imageFolder"
    echo " "
    echo "Output directory: $imageFolder"
    echo " "
}

# Remove trailing slashes
website_link="${website_link%/}"

# Remove /page if present
website_link="${website_link%/page*}"

# Define output HTML file
output_html="website.html"

# Define an array of user agents
user_agents=(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.9999.99 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36"
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36"
    # Add more user agents here
)

download_website() {
    local website_link="$1"
    local output_file="$2"
    local user_agent="${user_agents[0]}"  # Choose the first user agent for downloading the website

    domain=$(echo "$1" | grep -oP '^https?://\K[^/]+')
    echo "Downloading website from $domain..."

    # Try downloading the website until a non-empty title is obtained
    while true; do
        if wget --user-agent="$user_agent" -O "$output_file" "$website_link" >/dev/null 2>&1; then
            title=$(sed -n 's/.*<title>\(.*\)<\/title>.*/\1/p' "$output_file" | sed 's/&amp;/\&/g')
            if [ -n "$title" ]; then
                echo "Website downloaded successfully."
                printf -v formatted_title "Title: %s" "$title"
                echo "$formatted_title"
                break
            else
                echo "Empty title found. Retrying..."
            fi
        else
            echo "Failed to download website."
            exit 1
        fi
    done
}

# Prompt user for the last page number
read -p "Enter the last page number: " last_page_number

directoryCreate
output_html="$imageFolder/$output_html"

# Loop through pages starting from 1 until the last page number is reached
page_number=0
while true; do
    # Increment page number
    ((page_number++))
    if [ "$page_number" -gt "$last_page_number" ]; then
        echo "Reached last page. Terminating."
        break
    fi
    page_url="${website_link}/page/${page_number}/"
    echo "Processing page: $page_url"
    # Download the website using the first user agent
    download_website "$page_url" "$output_html"
    # Call the image download script for the current page
    bash ./img.sh "$output_html" "$imageFolder"
    # Remove the downloaded HTML file
    rm "$output_html"
done

echo "Your hentai has been downloaded."
echo "Please Use Me Again Sometime~"
echo " "
echo "Just press mi Enter Button rq~"
read
echo "KTHXBYE"
