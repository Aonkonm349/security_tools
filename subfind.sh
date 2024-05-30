#!/bin/bash

# Check if Sublist3r and MassDNS are installed
command -v sublist3r >/dev/null 2>&1 || { echo >&2 "Sublist3r is required but it's not installed. Aborting."; exit 1; }
command -v massdns >/dev/null 2>&1 || { echo >&2 "MassDNS is required but it's not installed. Aborting."; exit 1; }

# Function to get user input for domain or IP
get_input() {
    read -p "Enter the domain or IP address: " input
}

# Function to create a folder with the IP name
create_folder() {
    output_dir="/home/aonkon/Downloads/subdomain/$input"
    mkdir -p "$output_dir"
}

# Function to find subdomains using Sublist3r
find_subdomains() {
    echo "Finding subdomains for $input..."
    sublist3r -d $input -o "$output_dir/subdomains_$input.txt" >/dev/null 2>&1
    #sublist3r -d $input -o "$output_dir/subdomains_$input.txt" -b >/dev/null 2>&1
    #echo "Subdomains and hidden subdomains found. Check $output_dir/subdomains_$input.txt for the results."
}

# Function to resolve subdomains using MassDNS
resolve_subdomains() {
    echo "Resolving subdomains using MassDNS..."
    massdns -r /home/aonkon/tools/massdns/lists/resolvers.txt -t A -o S "$output_dir/subdomains_$input.txt" -w "$output_dir/resolved_subdomains_$input.txt" >/dev/null 2>&1
    
    # Remove extra characters and save to a new file
    sed 's/A.*//' "$output_dir/resolved_subdomains_$input.txt" | sed 's/CN.*//' | sed 's/\..$//' > "$output_dir/final_resolved_subdomains_$input.txt"
    echo "Subdomains resolved. Check $output_dir/final_resolved_subdomains_$input.txt for the results."
    
    # Delete the temporary resolved subdomains file
    rm "$output_dir/resolved_subdomains_$input.txt"
}

# Main function
main() {
    get_input
    create_folder
    find_subdomains
    resolve_subdomains
}

# Call the main function
main
