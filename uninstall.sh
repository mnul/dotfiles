#!/bin/bash

set -euo pipefail

declare -A DOTFILES=(
    [".bashrc"]="$HOME/.bashrc"
    [".zshrc"]="$HOME/.zshrc"
    [".profile"]="$HOME/.profile"
    [".zprofile"]="$HOME/.zprofile"
    [".tmux.conf"]="$HOME/.tmux.conf"
)

for source_name in "${!DOTFILES[@]}"; do
    target_file="${DOTFILES[$source_name]}"
    backup_file="${target_file}.dtbak"

    if [ -h "$target_file" ] || [ -f "$target_file" ]; then
        rm -f "$target_file"
    fi

    if [ -f "$backup_file" ]; then
        mv "$backup_file" "$target_file"
    fi
done