# Dependencies

Tools required by these dotfiles. Grouped by platform where relevant.

## Shell & Terminal

| Tool | Notes |
|------|-------|
| [nushell](https://www.nushell.sh/) | Default shell |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart `cd` — `source ~/.zoxide.nu` in config |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder — used by nvim pickers |
| [thefuck](https://github.com/nvbn/thefuck) | `fuck` alias in config.nu |
| [kanata](https://github.com/jtroo/kanata) | Homerow mods / key remapping |

## Editor

| Tool | Notes |
|------|-------|
| [neovim](https://neovim.io/) >= 0.10 | LazyVim base config |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Required by snacks.nvim grep/search |
| [fd](https://github.com/sharkdp/fd) | Required by snacks.nvim file finder |
| [clang](https://clang.llvm.org/) | Treesitter compiler (`CC=clang`), clangd LSP |
| [lazygit](https://github.com/jesseduffield/lazygit) | Snacks lazygit integration + standalone |
| [node.js](https://nodejs.org/) | Required by several LSPs and markdown-preview.nvim |
| [claude-code](https://github.com/anthropics/claude-code) | claudecode.nvim integration (`npm install -g @anthropic-ai/claude-code`) |
| [codex](https://github.com/openai/codex) | codex.nvim integration |

### Mason-managed (auto-installed by nvim)

| Tool | Notes |
|------|-------|
| clangd | C/C++ LSP |
| lua-language-server | Lua LSP |
| black | Python formatter |
| pylint | Python linter |

## File Manager

| Tool | Notes |
|------|-------|
| [yazi](https://github.com/sxyazi/yazi) | CLI file manager |

## Git

| Tool | Notes |
|------|-------|
| [lazygit](https://github.com/jesseduffield/lazygit) | TUI git client |

## Development Runtimes

| Tool | Notes |
|------|-------|
| [rust / cargo](https://www.rust-lang.org/) | `.cargo/bin` in PATH, cargo completions |
| [node.js / nvm](https://github.com/nvm-sh/nvm) | `~/.nvm/versions/node/v24.11.1/bin` in PATH |
| [uv](https://github.com/astral-sh/uv) | Python package manager, uv completions |
| [poetry](https://python-poetry.org/) | Python dependency management, poetry completions |

## Linux Only

| Tool | Notes |
|------|-------|
| [hyprland](https://hyprland.org/) | Wayland compositor |
| [waybar](https://github.com/Alexays/Waybar) | Status bar |
| [mako](https://github.com/emersion/mako) | Notification daemon |
| [fuzzel](https://codeberg.org/dnkl/fuzzel) | App launcher |
| [ghostty](https://ghostty.org/) | Terminal emulator |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer |
| [tmux-sessionizer](https://github.com/ThePrimeagen/tmux-sessionizer) | Session manager |
| [qutebrowser](https://qutebrowser.org/) | Vim-style browser |
| [greetd](https://sr.ht/~kennylevinsen/greetd/) | Login manager |
| [zellij](https://zellij.dev/) | Terminal workspace (config present, optional) |
| [dolphin](https://apps.kde.org/dolphin/) | GUI file manager (Hyprland keybind) |

## Windows Only

| Tool | Notes |
|------|-------|
| [win32yank](https://github.com/equalsraf/win32yank) | Clipboard bridge for WSL (used by nvim WSL clipboard config) |
| Windows Terminal | `WT_SESSION`/`WT_PROFILE_ID` env vars forwarded to claudecode/codex |