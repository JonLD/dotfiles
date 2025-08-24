# Arch Linux Setup Documentation

## Core System
- **OS**: Arch Linux
- **Shell**: Nushell (`/usr/bin/nu`)
- **Editor**: Neovim with LazyVim configuration

## Window Manager & Desktop
- **Window Manager**: Hyprland (Wayland compositor)
- **Application Launcher**: fuzzel (you have this installed)
- **Status Bar**: Waybar
- **Notification Daemon**: Mako
- **Terminal**: Ghostty
- **File Manager**: Dolphin (configured in Hyprland)

## Terminal & CLI Tools
- **Terminal Multiplexer**: tmux (with nushell as default shell)
- **File Manager (CLI)**: Yazi with custom themes (gruvbox-dark, kanagawa)
- **Prompt**: Starship (configured in nushell)
- **Session Manager**: tmux-sessionizer

## Browsers & Web
- **Browser**: Qutebrowser (Vim-like keybindings)

## Development
- **Editor**: Neovim with extensive plugin setup
  - LazyVim as base configuration
  - AI plugins, LSP, Git integration
  - Custom themes and utilities
- **Version Control**: Git (with Neovim integration)

## 3D Printing
- **Slicer**: Bambu Studio (installed via AUR)

## Input & Keyboard
- **Keyboard Layout**: UK (GB) layout
- **Caps Lock**: Remapped to Ctrl modifier
- **Touchpad**: Natural scroll enabled

## Themes & Appearance
- **Terminal Colors**: Dark+ theme (VS Code inspired)
- **Yazi Themes**: Gruvbox Dark, Kanagawa
- **Hyprland**: Minimal borders, no gaps, gray color scheme

## Hardware Configuration

### Cellular Modem (MediaTek T7xx)
This laptop has a built-in cellular modem that was previously used by the seller. Currently **disabled** to prevent error messages during boot/login.

**Current Status:** Blacklisted (driver disabled)

**To enable cellular functionality:**
1. Remove the blacklist:
   ```bash
   sudo rm /etc/modprobe.d/blacklist-cellular.conf
   ```

2. Install ModemManager for proper modem handling:
   ```bash
   sudo pacman -S modemmanager
   sudo systemctl enable --now ModemManager
   ```

3. Reload the driver:
   ```bash
   sudo modprobe mtk_t7xx
   # Or just reboot
   ```

4. Check modem status:
   ```bash
   mmcli -L  # List modems
   mmcli -m 0  # Check modem 0 status
   ```

**SIM Card Options:**
- Use regular phone SIM (same as phone plans)
- Avoid "mobile broadband" specific plans (overpriced)
- Three/Smarty tend to have best data allowances
- Consider adding second line to existing phone plan

**To disable again:**
```bash
echo "blacklist mtk_t7xx" | sudo tee /etc/modprobe.d/blacklist-cellular.conf
```

## Config Management
- **Dotfiles Location**: `/home/jonld/.config/dotfiles/`
- **Nushell Config Manager**: nudot (custom configuration tool)

## Key Bindings Philosophy
- Vim-style navigation throughout (Hyprland, tmux, Neovim, Qutebrowser)
- Consistent `hjkl` movement patterns
- tmux prefix: `Ctrl-Space` (avoids vim conflicts)