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
        linux: null
        macos: null
      }
    }
    {
      name: "nvim"
      source: "nvim"
      targets: {
        windows: "AppData/Local/nvim"
        linux: null
        macos: null
      }
    }
    {
      name: "qutebrowser"
      source: "qutebrowser"
      targets: {
        windows: "AppData/Roaming/qutebrowser"
        linux: null
        macos: null
      }
    }
    {
      name: "yazi"
      source: "yazi"
      targets: {
        windows: "AppData/Roaming/yazi/config"
        linux: null
        macos: null
      }
    }
    {
      name: "claude-md"
      source: "claude-md"
      targets: {
        windows: ".claude/CLAUDE.md"
        linux: null
        macos: null
      }
    }
  ]
}