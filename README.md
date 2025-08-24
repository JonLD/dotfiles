# Dotfiles

Personal configuration files managed with nudot (Nushell Dotfile Manager).

## Quick Start

### Setup
```bash
# Attach all dotfiles (create symlinks)
nu nudot.nu attach

# Check status
nu nudot.nu status
```

### Adding New Configs
```bash
# Add a config directory
nu nudot.nu add ~/.config/nvim

# Add with custom name
nu nudot.nu add ~/.zshrc --name zsh

# Add with custom source directory name
nu nudot.nu add ~/.gitconfig --source git-config
```

## nudot Commands

### Core Commands
- `nu nudot.nu attach [--force] [--dry-run]` - Attach all dotfiles (create symlinks)
- `nu nudot.nu list` - List all configured dotfiles
- `nu nudot.nu status` - Show detailed status of all dotfiles
- `nu nudot.nu detach` - Detach all symlinks (files stay in repo)
- `nu nudot.nu help` - Show full help message

### Management Commands
- `nu nudot.nu add <path> [--name <n>] [--force] [--config-only]` - Add file/directory to dotfiles
- `nu nudot.nu remove <path> [--force|--backup]` - Remove file from dotfiles management

### Useful Flags
- `--force` - Override existing files without backup
- `--dry-run` - Preview changes without making them
- `--backup` - Create backup before making changes
- `--config-only` - Add config path only (for cross-platform setup)

## Examples

```bash
# Add neovim config
nu nudot.nu add ~/.config/nvim

# Add zsh config with custom name
nu nudot.nu add ~/.zshrc --name zsh

# Preview what would be attached
nu nudot.nu attach --dry-run

# Force attach and override existing files
nu nudot.nu attach --force

# Remove neovim from management
nu nudot.nu remove ~/.config/nvim

# Remove and backup existing file
nu nudot.nu remove ~/.config/nvim --backup
```

## How It Works

- Configuration is managed in `nudot-config.nu`
- Files are stored with simple names in the repo (`nvim/`, `gitconfig`, etc.)
- Symlinks are created from target locations to your dotfiles repo
- Cross-platform paths can be configured for Windows/Linux/macOS

## Current Configurations

Run `nu nudot.nu list` to see all managed configurations.