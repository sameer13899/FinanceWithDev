#!/bin/bash

# Set the output file
OUTPUT_FILE="soni_usage.csv"

# Initialize the CSV file with headers
echo "File,Imported Item" > "$OUTPUT_FILE"

# Scan through each JavaScript or TypeScript file in the project
find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \) | while read -r file; do
    # Extract lines with imports from "@sameer/soni"
    grep -E 'import .* from "@sameer/soni' "$file" | while read -r line; do
        # Extract the imported items
        IMPORTS=$(echo "$line" | awk -F'{|}' '{print $2}' | sed 's/,/ /g' | tr -d ' ')
        
        # Write each imported item to the CSV
        for item in $IMPORTS; do
            echo "$file,$item" >> "$OUTPUT_FILE"
        done
    done
done

echo "CSV file generated at $OUTPUT_FILE"
