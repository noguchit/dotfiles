#!/bin/bash

# Script to copy files matching yyyy-mm-ddxxx.pdf pattern to a subdirectory
# Usage: ./copy_pdf_files.sh [target_directory]

# Set default target directory if not provided
TARGET_DIR="${1:-pdf_files}"

# Create target directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    echo "Creating target directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# Find and copy files matching the pattern
# The pattern looks for:
# - 4 digits (year)
# - followed by a hyphen
# - followed by 2 digits (month)
# - followed by a hyphen
# - followed by 2 digits (day)
# - followed by any characters
# - ending with .pdf

count=0
for file in $(find . -maxdepth 1 -type f -name "2010-[0-9][0-9]-[0-9][0-9]*.pdf"); do
    # Skip files that are already in the target directory
    if [[ "$file" == "./$TARGET_DIR/"* ]]; then
        continue
    fi
    
    # Copy the file to target directory
    cp "$file" "$TARGET_DIR/"
    echo "Copied: $file to $TARGET_DIR/"
    ((count++))
done

# Print summary
if [ $count -eq 0 ]; then
    echo "No files matching the pattern were found."
else
    echo "Total files copied: $count"
fi
