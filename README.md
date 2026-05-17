# Homelab Dotfiles Optimization Engine

Idempotent, multi-OS, cross-user configuration matrix optimized for Proxmox hypervisors, Debian/Ubuntu LXCs, and CachyOS workstations. Safe for deployment under both standard users and the `root` shell context.

## Architectural Design

*   **Absolute Idempotency:** Bootstrapper checks link mapping and file parity before mutating states. Safe for automated execution via cron schedulers.
*   **Decoupled Aliases:** Core command shortcuts are isolated in `~/.shell_aliases` to prevent shell-specific initialization pollution and allow atomic updates.
*   **Privilege Boundary Protection:** The installer forces copy operations over symbolic links if run as `root` from a non-root home workspace, neutralizing privilege escalation vectors.

## Dependency Prerequisite Matrix

Verify these binaries exist on the target node prior to executing the bootstrapper:

| Component | Debian/Ubuntu Tarball/APT | Arch / CachyOS (Yay) | Purpose |
| :--- | :--- | :--- | :--- |
| **Oh My Posh** | Direct binary install to `/usr/local/bin` | `yay -S oh-my-posh-bin` | Terminal Prompt Engine |
| **Zoxide** | `sudo apt install zoxide` | `yay -S zoxide` | Smart Navigation |
| **TheFuck** | `sudo apt install thefuck` | `yay -S thefuck` | CLI Correction |
| **Tmux** | `sudo apt install tmux` | `yay -S tmux` | Terminal Multiplexer |

## Deployment Strategy

### Manual Bootstrapping
Clone directly into the target environment workspace and execute:
```bash
git clone https://github.com/mnul/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```
### Root User Context Sync
To enforce visual and structural parity within the administrative root shell, clone the repository inside the root home directory directly:
```bash
sudo -i
git clone https://github.com/mnul/dotfiles.git /root/dotfiles
cd /root/dotfiles
chmod +x install.sh
./install.sh
```

## Automated Configuration Enforcement (Cron)
To prevent configuration drift across homelab nodes, embed this block into the local crontab (`crontab -e`):
```cron
0 2 * * * cd ~/dotfiles && git pull --quiet && ./install.sh > /dev/null
```
## Repository File Structure
- `install.sh` - Idempotent, multi-user system deployment engine.

- `uninstall.sh` - Safe state roll-back tool (restores .dtbak files).

- `.shell_aliases` - Centralized command matrix for cross-platform execution.

- `.bashrc` - Interactive initialization profile for headless servers and fallback environments.

- `.zshrc` - Workstation shell orchestration environment.

- `.profile` / `.zprofile` - Non-interactive login logic and managed SSH-agent lifecycle.

- `.tmux.conf` - Multiplexer configuration profile.

- `togemini.sh` - Text-context compilation tool optimized for LLM debugging.

## License

This repository is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for the full legal text.

### Disclaimer
The configuration files, scripts, and automation assets contained in this repository are provided "as is" without warranty of any kind, express or implied. Use at your own risk. The author assumes no liability for broken infrastructure, data loss, or system instability resulting from the execution of these files.