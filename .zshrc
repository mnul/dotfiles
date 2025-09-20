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
#source ~/lscolors.sh

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
# An SSD can handle a large history
HISTSIZE=9999
# shellcheck disable=SC2034
SAVEHIST=9999
## History command configuration
setopt extended_history # record timestamp of command in HISTFILE
# delete duplicates first when HISTFILE size exceeds HISTSIZE
# setopt hist_expire_dups_first
setopt hist_ignore_dups # Don't add duplicate entries
setopt hist_ignore_space # ignore commands that start with space
# show command with history expansion to user before running it
setopt hist_verify
setopt inc_append_history # add commands to HISTFILE in order of execution
setopt share_history # share command history data
setopt hist_find_no_dups # don't display duplicates in reverse search
setopt hist_reduce_blanks # remove superfluous blanks
unsetopt correct_all # Don't autocorrect when thefuck does it better.
setopt extended_glob # Muh globbing
setopt equals # use "=" to point to the path of an executable
setopt prompt_subst # Expansion
setopt interactivecomments # Comments in the interactive shell
setopt auto_continue # Send CONT signal automatically when disowning jobs
setopt auto_param_slash # implicit "cd" if the command is a path

autoload -U colors && colors
PS1="%{$fg[green]%}[%{$reset_color%} %{$fg[blue]%}%1~%{$reset_color%} %{$fg[green]%}]%{$reset_color%}$%b "

# custom aliases
alias ll='ls --color=auto -alF'
alias c='clear'
alias g='git'
alias szsh='source ~/.zshrc'
alias dc='docker compose'
alias dps='docker ps -a'
alias dcud='docker compose up -d'
alias dcu='docker compose up'
alias dip='docker image prune -a'
alias dsp='docker system prune -a'
alias sau='sudo apt update && sudo apt dist-upgrade'


# zsh plugins
#zinit light zsh-users/zsh-autosuggestions # zsh autosuggestions plugin
zinit wait lucid atload'_zsh_autosuggest_start; unalias zi' light-mode for zsh-users/zsh-autosuggestions # Autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting  # fast syntax highlighting for zsh
zinit light zsh-users/zsh-completions  # additional completions for zsh
zinit light zpm-zsh/theme-neutral # neutral theme for zsh

# add zoxide
eval "$(zoxide init zsh)" # --cmd cd # zoxide is a smarter cd command. It tracks your most used directories, and allows you to quickly navigate to them.

# add thefuck
# Thefuck is a tool that corrects your previous console command.
# It suggests the correct command based on the previous command and allows you to execute it with a simple command.
# It is a great tool for correcting typos and mistakes in your console commands.
eval "$(thefuck --alias)"