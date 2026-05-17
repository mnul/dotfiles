#!/bin/bash
set -euo pipefail

declare -A DOTFILES=(
  [".bashrc"]="$HOME/.bashrc"
  [".zshrc"]="$HOME/.zshrc"
  [".profile"]="$HOME/.profile"
  [".zprofile"]="$HOME/.zprofile"
  [".tmux.conf"]="$HOME/.tmux.conf"
  [".shell_aliases"]="$HOME/.shell_aliases"
)

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_USER="$(whoami)"
EUID_VAL="$(id -u)"

echo "==> Deploying dotfiles for user: $CURRENT_USER (UID: $EUID_VAL)"
echo "==> Repository root directory: $REPO_DIR"

FORCE_COPY=0
if [ "$EUID_VAL" -eq 0 ]; then
  if [[ "$REPO_DIR" =~ ^/home/ ]]; then
    echo "[SECURITY ALERT] Running as root but repository is located in /home."
    echo "                 Forcing physical copy of files to /root/ to prevent privilege escalation."
    FORCE_COPY=1
  fi
fi

for source_name in "${!DOTFILES[@]}"; do
  source_file="$REPO_DIR/$source_name"
  target_file="${DOTFILES[$source_name]}"
  
  if [ ! -f "$source_file" ]; then
    echo "Warning: Source file $source_file does not exist. Skipping." >&2
    continue
  fi

  if [ "$FORCE_COPY" -eq 1 ]; then
    if [ -h "$target_file" ]; then
      echo "Removing existing symlink at root target: $target_file"
      rm "$target_file"
    fi

    if [ -f "$target_file" ]; then
      if cmp -s "$source_file" "$target_file"; then
        echo "Ok: $target_file is already up to date (identical content)."
        continue
      fi
      backup_file="${target_file}.dtbak"
      if [ -e "$backup_file" ]; then
        echo "Warning: Backup $backup_file already exists. Overwriting current file without updating backup."
        rm -f "$target_file"
      else
        echo "Backing up real file: $target_file -> $backup_file"
        mv "$target_file" "$backup_file"
      fi
    fi

    echo "Copying config: $source_file -> $target_file"
    cp "$source_file" "$target_file"
    chmod 600 "$target_file"
  else
    if [ -h "$target_file" ]; then
      current_link=$(readlink "$target_file")
      if [ "$current_link" = "$source_file" ]; then
        echo "Ok: $target_file is already correctly symlinked."
        continue
      fi
      echo "Removing outdated symlink: $target_file"
      rm "$target_file"
    fi

    if [ -e "$target_file" ] && [ ! -h "$target_file" ]; then
      backup_file="${target_file}.dtbak"
      if [ -e "$backup_file" ]; then
        echo "Warning: Backup $backup_file already exists. Overwriting current file without updating backup."
        rm -f "$target_file"
      else
        echo "Backing up real file: $target_file -> $backup_file"
        mv "$target_file" "$backup_file"
      fi
    fi

    mkdir -p "$(dirname "$target_file")"
    echo "Creating symlink: $target_file -> $source_file"
    ln -s "$source_file" "$target_file"
  fi
done

echo "==> Deployment process completed successfully."