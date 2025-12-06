#!/bin/bash
# Rename exported workflow JSON files based on their "name" field
# Converts to lowercase, replaces spaces/special chars with underscores

WORKFLOWS_DIR="${1:-data/n8n/workflows}"

for file in "$WORKFLOWS_DIR"/*.json; do
    [ -f "$file" ] || continue

    # Extract the "name" field from JSON
    name=$(grep -o '"name": *"[^"]*"' "$file" | head -1 | sed 's/"name": *"\(.*\)"/\1/')

    if [ -z "$name" ]; then
        echo "Skipping $file - no name found"
        continue
    fi

    # Convert to lowercase, replace non-alphanumeric with underscore, collapse multiple underscores
    new_name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_//;s/_$//')
    new_file="$WORKFLOWS_DIR/${new_name}.json"

    # Skip if already correctly named
    if [ "$file" = "$new_file" ]; then
        echo "Already named: $new_name.json"
        continue
    fi

    # Rename file (overwrite if exists - files are git versioned)
    mv -f "$file" "$new_file"
    echo "Renamed: $(basename "$file") -> ${new_name}.json"
done
