#!/bin/bash

set -euo pipefail

# Load configuration
CONFIG_FILE="config.sh"
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Configuration file '$CONFIG_FILE' not found."
  exit 1
fi
source "$CONFIG_FILE"

# Define variables for paths and settings
AUDIBLE_CLI="audible"
AAXTOMP3_PATH="/Users/tnoguchi/AAXtoMP3/AAXtoMP3"
OUTPUT_DIR="$HOME/Documents/Audiobooks"
INPUT_FILE="asin.txt"
LOG_FILE="$OUTPUT_DIR/process.log"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Check dependencies
if ! command -v "$AUDIBLE_CLI" &>/dev/null; then
  echo "Error: Audible CLI is not installed or not in PATH."
  exit 1
fi

# Download library list and process ASINs
# Keep the first five ASINs
if "$AUDIBLE_CLI" library list >$OUTPUT_DIR/input.txt; then
  sed 's/:.*//' $OUTPUT_DIR/input.txt |sed '6,$d' >"$INPUT_FILE"
else
  echo "Error: Failed to retrieve library list."
  exit 1
fi


# Check if input file exists and is not empty
if [[ ! -s "$INPUT_FILE" ]]; then
  echo "Error: Input file '$INPUT_FILE' does not exist or is empty."
  exit 1
fi

# Log start
echo "Starting processing at $(date)" >>"$LOG_FILE"


# Process each ASIN
while read -r line; do
  [[ -z "$line" ]] && continue # Skip blank lines
  
  echo "Processing ASIN: $line"
  
  if "$AUDIBLE_CLI" download -a "$line" --aaxc --cover --cover-size 1215 --chapter --output-dir "$OUTPUT_DIR"; then
    echo "$(date): Download successful for $line" >>"$LOG_FILE"
    
    for file in "$OUTPUT_DIR"/*.aaxc; do
      [[ ! -f "$file" ]] && continue
      
      echo "Processing file: $file"
      
      if "$AAXTOMP3_PATH" --authcode "$AUTHCODE" -c -e:m4b --use-audible-cli-data "$file"; then
        rm -f "$file"
        echo "$(date): Conversion successful for $file" >>"$LOG_FILE"
        find . -maxdepth 1 -type f -name "*.aaxc" -delete
      else
        echo "$(date): Error: Conversion failed for $file" >>"$LOG_FILE"
        find . -maxdepth 1 -type f -name "*.aaxc" -delete
      fi
      
    done
    
  else
    echo "$(date): Error: Failed to download $line" >>"$LOG_FILE"
    continue
  fi
  
done <"$INPUT_FILE"

# Log completion
echo "Processing completed at $(date)" >>"$LOG_FILE"
echo "Script completed."
