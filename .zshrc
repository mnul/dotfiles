export PATH=$PATH:$HOME/.local/bin

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/dotfiles/nighthawk.yaml)"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# dircolors
source ~/lscolors.sh

# custom aliases
alias ll='ls --color=auto -alF'
alias c='clear'
alias g='git'
alias szsh='source ~/.zshrc'
alias dc='docker compose'
alias dcud='docker compose up -d'
alias dcu='docker compose up'
alias sau='sudo apt update && sudo apt dist-upgrade'


# zsh plugins
zinit light zsh-users/zsh-autosuggestions # zsh autosuggestions plugin
zinit light zdharma-continuum/fast-syntax-highlighting  # fast syntax highlighting for zsh
zinit light zsh-users/zsh-completions  # additional completions for zsh
zinit light zpm-zsh/theme-neutral # neutral theme for zsh
