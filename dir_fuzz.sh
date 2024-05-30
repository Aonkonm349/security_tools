#!/bin/bash



# Check if Gobuster is installed
if ! command -v gobuster &> /dev/null; then
    echo "Error: Gobuster is not installed. Please install Gobuster (https://github.com/OJ/gobuster) and try again."
    exit 1
fi

# Prompt for the website's IP address or domain
read -p "Enter the website's IP address or domain: " WEBSITE_IP

# Prompt for HTTP or HTTPS protocol
read -p "Choose protocol (a) HTTP or (b) HTTPS: " PROTOCOL

# Validate protocol choice
if [ "$PROTOCOL" == "a" ]; then
    WEBSITE_URL="http://$WEBSITE_IP"
elif [ "$PROTOCOL" == "b" ]; then
    WEBSITE_URL="https://$WEBSITE_IP"
else
    echo "Invalid protocol choice. Please enter 'a' for HTTP or 'b' for HTTPS."
    exit 1
fi

# Define the path to the custom wordlist in the home directory
WORDLIST_PATH="$HOME/directory-list-2.3-medium.txt"

# Check if the wordlist exists
if [ ! -f "$WORDLIST_PATH" ]; then
    echo "Error: Wordlist not found at $WORDLIST_PATH. Please create or download the wordlist and try again."
    exit 1
fi

# Define the output directory
DOWNLOADS_DIR="/home/aonkon/Downloads/IP_dir_fuzz"

# Create the output directory if it doesn't exist
mkdir -p "$DOWNLOADS_DIR"



# Define the output file name based on the website IP or domain
OUTPUT_FILE="$DOWNLOADS_DIR/result_${WEBSITE_IP//./_}.txt"

# Function to clean the output file
clean_output_file() {
    sed -i 's///g; s/\"//g; s/\[0m//g' "$1"
}

# Perform directory fuzzing with Gobuster
gobuster dir -u "$WEBSITE_URL" -w "$WORDLIST_PATH" -x php,sh,txt,cgi,html,css,js,py,conf -o "$OUTPUT_FILE" -k -s "200,204,301,302,307,403,500" --status-codes-blacklist=""



# Clean the output file
clean_output_file "$OUTPUT_FILE"

echo "Directory fuzzing results saved to $OUTPUT_FILE"
