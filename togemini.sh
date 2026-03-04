#!/bin/bash
# Location: ~/dotfiles/togemini.sh
# 
# INSTALLATION:
# Add the following line to your .zshrc and .bashrc:
# [ -f "$HOME/dotfiles/togemini.sh" ] && source "$HOME/dotfiles/togemini.sh"

togemini() {
    # We use the .llm.txt extension to allow for easy git-ignoring
    local output_file="context.llm.txt"
    
    # Optional: If you provide an argument, use it as the base name
    if [ -n "$1" ]; then
        output_file="${1}.llm.txt"
    fi

    echo "Generating context file: $output_file"
    
    # Clear the file and add absolute path for reference
    {
        echo "Project Context"
        echo "Absolute Path: $(pwd)"
        echo "Generated on: $(date)"
        echo "---"
    } > "$output_file"

    # Find ALL files up to depth 8, excluding binaries and metadata
    find . -maxdepth 8 -type f \
        -not -path '*/.git/*' \
        -not -path '*/.terraform/*' \
        -not -path '*/bin/*' \
        -not -path '*/obj/*' \
        -not -name '*.llm.txt' \
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
            # Skip files larger than 500KB (likely data/logs)
            if [[ $(find "$file" -size +500k) ]]; then continue; fi

            echo "$file" >> "$output_file"
            echo "---" >> "$output_file"
            cat "$file" >> "$output_file"
            echo -e "\n---\n" >> "$output_file"
        done

    echo "Done! Upload $output_file to Gemini."
}