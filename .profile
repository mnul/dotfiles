#!/bin/bash
# .profile - Single Source of Truth for SSH Agent

SSH_ENV="$HOME/.ssh/agent-environment"

start_agent() {
    mkdir -p "$(dirname "$SSH_ENV")"
    ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    
    if [ "$(id -u)" -eq 0 ]; then
        if [ -f "/home/manu/.ssh/manu-homelab" ]; then
            ssh-add /home/manu/.ssh/manu-homelab
        elif [ -f "$HOME/.ssh/manu-homelab" ]; then
            ssh-add "$HOME/.ssh/manu-homelab"
        fi
    else
        [ -f "$HOME/.ssh/manu-homelab" ] && ssh-add "$HOME/.ssh/manu-homelab"
    fi
}

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep "${SSH_AGENT_PID}" | grep ssh-agent > /dev/null || start_agent
else
    start_agent
fi