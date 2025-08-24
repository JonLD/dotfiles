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
        linux: "/home/jonld/.config/nushell"
        macos: null
      }
    }
    {
      name: "nvim"
      source: "nvim"
      targets: {
        windows: "AppData/Local/nvim"
        linux: "/home/jonld/.config/nvim"
        macos: null
      }
    }
    {
      name: "qutebrowser"
      source: "qutebrowser"
      targets: {
        windows: "AppData/Roaming/qutebrowser"
        linux: "/home/jonld/.config/qutebrowser"
        macos: null
      }
    }
    {
      name: "yazi"
      source: "yazi"
      targets: {
        windows: "AppData/Roaming/yazi/config"
        linux: "/home/jonld/.config/yazi"
        macos: null
      }
    }
    {
      name: "claude-md"
      source: "claude-md"
      targets: {
        windows: ".claude/CLAUDE.md"
        linux: "/home/jonld/.claude/CLAUDE.md"
        macos: null
      }
    }
    {
      name: "ghostty"
      source: "ghostty"
      targets: {
        windows: null
        linux: "/home/jonld/.config/ghostty"
        macos: null
      }
    }
    {
      name: "hypr"
      source: "hypr"
      targets: {
        windows: null
        linux: "/home/jonld/.config/hypr"
        macos: null
      }
    }
  ]
}