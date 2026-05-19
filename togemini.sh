#!/bin/bash

togemini() {
    local output_file="context.llm.txt"
    
    if [ -n "${1:-}" ]; then
        output_file="${1}.llm.txt"
    fi

    echo "Generating context file: $output_file"
    
    {
        echo "Project Context"
        echo "Absolute Path: $(pwd)"
        echo "Generated on: $(date)"
        echo "---"
    } > "$output_file"

    find . -maxdepth 8 -type f \
        -size -500k \
        -not -path '*/.git/*' \
        -not -path '*/.terraform/*' \
        -not -path '*/bin/*' \
        -not -path '*/obj/*' \
        -not -path '*/node_modules/*' \
        -not -path '*/__pycache__/*' \
        -not -name '*.llm.txt' \
        -not -name '*.dtbak' \
        -not -name '*terraform.tfstate*' \
        -not -name '*.png' \
        -not -name '*.jpg' \
        -not -name '*.jpeg' \
        -not -name '*.gif' \
        -not -name '*.ico' \
        -not -name '*.pdf' \
        -not -name '*.zip' \
        -not -name '*.gz' \
        -not -name '*.tar' \
        -not -name '*.zst' \
        -not -name '*.pyc' \
        -print0 | while IFS= read -r -d '' file; do
            printf '%s\n---\n' "$file" >> "$output_file"
            cat "$file" >> "$output_file"
            printf '\n---\n\n' >> "$output_file"
        done

    echo "Done! Upload $output_file to Gemini."
}