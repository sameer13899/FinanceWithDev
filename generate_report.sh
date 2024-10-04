#!/bin/bash

# Accept project root directory and output file name from command-line arguments
PROJECT_ROOT=${1:-"."}   # Default to current directory if not provided
OUTPUT_FILE=${2:-"soni_usage.csv"}  # Default to "soni_usage.csv" if not provided

# Initialize the CSV file with headers
echo "Import Path" > "$OUTPUT_FILE"

# Create an associative array to track unique import paths
declare -A import_paths

# Find all relevant files and iterate over them
for file in $(find "$PROJECT_ROOT" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.jsx" -o -name "*.tsx" \)); do
    # Extract lines with any import from "@sameer/soni" or '@sameer/soni' package or its submodules
    while IFS= read -r line; do
        # Extract the import path
        IMPORT_PATH=$(echo "$line" | grep -o "['\"]@sameer/soni[^'\"]*['\"]" | tr -d "'\"")

        # Remove the '@' character from the IMPORT_PATH
        IMPORT_PATH="${IMPORT_PATH/@/}"

        # Add to associative array if it's not already present
        if [[ -n "$IMPORT_PATH" ]]; then
            import_paths["$IMPORT_PATH"]=1
        fi
    done < <(grep -E "import .* from[[:space:]]+['\"]@sameer/soni[^'\"]*['\"]" "$file")
done

# Write unique import paths to the CSV file
for path in "${!import_paths[@]}"; do
    echo "$path" >> "$OUTPUT_FILE"
done

echo "CSV file with unique import paths generated at $OUTPUT_FILE"
