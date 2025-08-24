# ⚠️ CRITICAL CODE STYLE RULE ⚠️
## NO TRAILING WHITESPACE EVER
- **NEVER add trailing whitespace on ANY lines**
- **NEVER add spaces or tabs on blank lines**
- **ALL blank lines must be completely empty (zero characters)**
- This rule applies to ALL file types: code, config, markdown, etc.
- User has been reminded multiple times - this is non-negotiable

# Shell Configuration
- Default shell: nushell

# Development Environment
- Platform: Windows
- Editor: Neovim with Lazy.nvim plugin manager
- Neovim config location: `C:\Users\jlloy\AppData\Local\nvim\`
- Neovim plugin data location: `C:\Users\jlloy\AppData\Local\nvim-data\`

# Code Style Preferences
- Strict adherence to the NO TRAILING WHITESPACE rule above

# ⚠️ CRITICAL BASH TOOL USAGE RULE ⚠️
## EVERY Bash command starts from the ORIGINAL working directory
- **NO directory navigation persists between separate Bash commands**
- **Each command execution is completely independent**
- **ALWAYS write complete, self-contained commands**

## Core Rule: Write COMPLETE commands
- ✅ `cd subdirectory && git add file && git commit && cd .. && git push`
- ❌ `cd subdirectory && git commit` then `git push` (push runs from wrong directory!)
- ❌ `cd subdirectory && git commit` then `cd .. && git push` (cd .. goes to parent of ORIGINAL dir!)

## Examples of Complete Commands:
- ✅ `cd project && npm install && npm build && cd .. && git add dist/`
- ✅ `git add file` (simple command from original directory)
- ❌ `cd project && npm install` then `npm build` (build runs from original dir!)

## Remember: Treat each Bash command as if it's the first command you're running

# Tool Usage Preferences
- **NEVER use replace_regex without asking first**
- Prefer regular Edit tool over replace_regex for code changes
- **ALWAYS prioritize Serena semantic tools for code navigation and understanding**
  - Use find_symbol, get_symbols_overview, find_referencing_symbols for code exploration
  - Semantic searching is faster, more efficient, and saves time and money
  - Avoid text-based search tools (Grep, Read entire files) unless absolutely necessary
  - Only read specific symbol bodies when needed, not entire files
- Only use replace_regex if normal Edit tool cannot handle the change
- Always show diffs for review before making changes

# Git Commit Preferences
- **NEVER add "Generated with Claude Code" or similar attribution to commit messages**
- Keep commit messages clean and focused on the actual changes
- No automated attribution footers in commits

# Communication Preferences
- Likes collaborative, team-oriented approach to problem solving
- Appreciates personal touches in conversation that acknowledge shared work

# Dotfiles Management
- Uses nudot (Nushell Dotfile Manager) for dotfiles management
- Located at: `/home/jonld/.config/dotfiles/`
- Key commands:
  - `nu nudot.nu attach` - Link all configs
  - `nu nudot.nu status` - Check symlink status
  - `nu nudot.nu add <path>` - Add new configs
  - `nu nudot.nu help` - Full documentation
- See README.md in dotfiles directory for complete usage guide
