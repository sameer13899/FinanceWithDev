#!/bin/bash

# Accept project root directory and output file name from command-line arguments
PROJECT_ROOT=${1:-"."}   # Default to current directory if not provided
OUTPUT_FILE=${2:-"soni_usage.csv"}  # Default to "soni_usage.csv" if not provided

# Initialize the CSV file with headers
echo "File,Import Path,Imported Item" > "$OUTPUT_FILE"

# Scan through each JavaScript or TypeScript file in the project
find "$PROJECT_ROOT" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) | while read -r file; do
    # Extract lines with any import from "@sameer/soni" or '@sameer/soni' package or its submodules
    grep -E "import .* from[[:space:]]+['\"]@sameer/soni[^'\"]*['\"]" "$file" | while read -r line; do
        # Extract the import path and the imported items
        IMPORT_PATH=$(echo "$line" | grep -o "['\"]@sameer/soni[^'\"]*['\"]" | tr -d "'\"")
        IMPORTS=$(echo "$line" | awk -F'{|}' '{print $2}' | sed 's/,/ /g' | tr -d ' ')

        # Write each imported item to the CSV
        for item in $IMPORTS; do
            echo "$file,$IMPORT_PATH,$item" >> "$OUTPUT_FILE"
        done
    done
done

echo "CSV file generated at $OUTPUT_FILE"
