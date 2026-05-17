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
if [ "$TERM" != "dumb" ] && command -v oh-my-posh &>/dev/null; then
    if [ -f "$HOME/dotfiles/nighthawk.yaml" ]; then
        eval "$(oh-my-posh init zsh --config "$HOME/dotfiles/nighthawk.yaml")"
    fi
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

# History Configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=9999
SAVEHIST=9999

setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history
setopt hist_find_no_dups
setopt hist_reduce_blanks
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