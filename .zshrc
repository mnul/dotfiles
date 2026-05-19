# ~/.zshrc

# Idempotent Path Resolution
if [[ -d "$HOME/.local/bin" ]]; then
    case ":$PATH:" in
        *":$HOME/.local/bin:"*) ;;
        *) export PATH="$PATH:$HOME/.local/bin" ;;
    esac
fi
[[ -d "$HOME/bin" ]] && export PATH="$PATH:$HOME/bin"

# Initialize Oh-My-Posh (Unified Workstation/Root Prompt)
if [ "$TERM" != "dumb" ] && command -v oh-my-posh &>/dev/null && [ -f "$HOME/dotfiles/nighthawk.yaml" ]; then
    eval "$(oh-my-posh init zsh --config "$HOME/dotfiles/nighthawk.yaml")"
else
    autoload -Uz colors && colors
    PROMPT="%{$fg[green]%}[%{$reset_color%}%{$fg[blue]%}%1~%{$reset_color%}%{$fg[green]%}]%{$reset_color%}$ "
fi

# Zinit Bootstrapper
ZINIT_DIR="$HOME/.local/share/zinit/zinit.git"
if [[ ! -f "$ZINIT_DIR/zinit.zsh" ]]; then
    command mkdir -p "$(dirname "$ZINIT_DIR")" && command chmod g-rwX "$(dirname "$ZINIT_DIR")"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_DIR"
fi
source "$ZINIT_DIR/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load Zinit Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ==========================================
# HISTORY & SHELL BEHAVIOUR
# ==========================================
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

# History Options
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history      # Writes to file immediately (better for tmux)
setopt share_history
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt hist_expire_dups_first  # Drops duplicates first when history hits 100k

# Shell Behaviour Enhancements
setopt autocd                  # Auto cd into directories without typing 'cd'
setopt nobeep                  # Disable annoying terminal error sounds
setopt numeric_glob_sort       # Sorts file1, file2, file10 in natural human order
unsetopt correct_all
setopt extended_glob
setopt equals
setopt prompt_subst
setopt interactivecomments
setopt auto_continue
setopt auto_param_slash

# --- COMPLETION SYSTEM INITIALIZATION (The Bug Fix) ---
zinit light zsh-users/zsh-completions

# Initialize compinit safely
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
    compinit -C
else
    compinit
fi
zinit cdreplay -q
# -----------------------------------------------------

# ==========================================
# ADVANCED COMPLETION & SEARCH ENGINE
# ==========================================

# 1. Zstyle Auto-Completion Upgrades
# Enables interactive arrow-key menu selection
zstyle ':completion:*' menu select
# Enables case-insensitive matching (type 'doc', gets 'Documents')
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# Cache completions to speed up the terminal
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# 2. FZF (Fuzzy Finder) Integration
if command -v fzf &>/dev/null; then
    # Wire fd into fzf to respect .gitignore and search insanely fast
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --color=always'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
        export FZF_DEFAULT_OPTS="--ansi"
    fi
    
    # Modern FZF zsh integration (requires fzf v0.48.0+)
    eval "$(fzf --zsh 2>/dev/null)"
fi

# Core Plugin Layer (Loaded strictly AFTER compinit)
zinit light zdharma-continuum/fast-syntax-highlighting
zinit wait lucid atload'_zsh_autosuggest_start' light-mode for zsh-users/zsh-autosuggestions

# Shell Binary Tools Initialization
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
command -v thefuck &>/dev/null && eval "$(thefuck --alias)"

# Ingestion Matrix
[ -f "$HOME/.shell_aliases" ] && source "$HOME/.shell_aliases"
alias szsh='source ~/.zshrc'

[ -f "$HOME/dotfiles/togemini.sh" ] && source "$HOME/dotfiles/togemini.sh"