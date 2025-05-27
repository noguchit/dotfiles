#!/bin/bash

# Define variables for paths and settings
AUDIBLE_CLI="audible"
AAXTOMP3_PATH="/Users/tnoguchi/AAXtoMP3/AAXtoMP3"
AUTHCODE="4e717233"
OUTPUT_DIR="$HOME/Documents/Audiobooks"
INPUT_FILE="asin.txt"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"
"$AUDIBLE_CLI" library list > input.txt
sed 's/:.*//' input.txt > asin.txt


# Process each line in the input file
while read -r line; do
    # Download the audiobook
    if ! "$AUDIBLE_CLI" download -a "$line" --aaxc --cover --cover-size 1215 --chapter --output-dir "$OUTPUT_DIR"; then
        echo "Error: Failed to download audiobook for ID $line"
        continue
    fi

    # Navigate to the output directory
    cd "$OUTPUT_DIR" || { echo "Error: Could not change to directory $OUTPUT_DIR"; exit 1; }

    # Convert .aaxc files to .m4b
    for file in *.aaxc; do
        if [[ -f "$file" ]]; then
            # name="${file%.aaxc}"
            # echo "Processing: $name"
            if ! "$AAXTOMP3_PATH" --authcode "$AUTHCODE" -c -e:m4b --use-audible-cli-data "$file"
                echo "Error: Failed to convert $file"        
            else       
            find . -maxdepth 1 -type f -delete; then
            fi 
        fi
done < "$INPUT_FILE"

echo "Script completed."
