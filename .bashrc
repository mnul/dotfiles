# ~/.bashrc

HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

PROMPT_DIRTRIM=2

case "$TERM" in
    xterm*|rxvt*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
        ;;
esac

if [ "$TERM" != "dumb" ]; then
    eval "$(dircolors -b)"
    
    # Direct relative pathing for dual-cloned repository architecture
    if command -v oh-my-posh &>/dev/null && [ -f "$HOME/dotfiles/nighthawk.yaml" ]; then
        eval "$(oh-my-posh init bash --config "$HOME/dotfiles/nighthawk.yaml")"
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u@\h \[\033[01;34m\]\w\[\033[00m\]\$ '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h \w\$ '
fi

# Idempotent Path Appender
if [[ -d "$HOME/.local/bin" ]]; then
    case ":$PATH:" in
        *":$HOME/.local/bin:"*) ;;
        *) export PATH="$PATH:$HOME/.local/bin" ;;
    esac
fi

if [ -d "$HOME/.bashrc.d" ]; then
    for script in "$HOME"/.bashrc.d/*; do
        [ -f "$script" ] && [ -x "$script" ] && . "$script"
    done
fi

command -v thefuck &>/dev/null && eval "$(thefuck --alias)"
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"

# Ingestion Matrix
[ -f "$HOME/.shell_aliases" ] && source "$HOME/.shell_aliases"
[ -f "$HOME/dotfiles/togemini.sh" ] && source "$HOME/dotfiles/togemini.sh"