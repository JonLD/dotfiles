# nudot configuration file
# This file is automatically managed by nudot, but can be manually edited
# You can add paths for other operating systems before switching to them

export def get-dotfiles-config [] {
  [
    {
      name: "nushell"
      source: "nushell"
      targets: {
        windows: "AppData/Roaming/nushell"
        linux: ".config/nushell"
        macos: null
      }
    }
    {
      name: "nvim"
      source: "nvim"
      targets: {
        windows: "AppData/Local/nvim"
        linux: ".config/nvim"
        macos: null
      }
    }
    {
      name: "qutebrowser"
      source: "qutebrowser"
      targets: {
        windows: "AppData/Roaming/qutebrowser"
        linux: ".config/qutebrowser"
        macos: null
      }
    }
    {
      name: "yazi"
      source: "yazi"
      targets: {
        windows: "AppData/Roaming/yazi/config"
        linux: ".config/yazi"
        macos: null
      }
    }
    {
      name: "claude-md"
      source: "claude-md"
      targets: {
        windows: ".claude/CLAUDE.md"
        linux: ".claude/CLAUDE.md"
        macos: null
      }
    }
  ]
}