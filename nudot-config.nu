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
      source: "CLAUDE.md"
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
    {
      name: "mako"
      source: "mako"
      targets: {
        windows: null
        linux: "/home/jonld/.config/mako"
        macos: null
      }
    }
    {
      name: "waybar"
      source: "waybar"
      targets: {
        windows: null
        linux: "/home/jonld/.config/waybar"
        macos: null
      }
    }
    {
      name: "tmux"
      source: "tmux"
      targets: {
        windows: null
        linux: "/home/jonld/.config/tmux"
        macos: null
      }
    }
    {
      name: "tmux-sessionizer"
      source: "tmux-sessionizer"
      targets: {
        windows: null
        linux: "/home/jonld/.config/tmux-sessionizer"
        macos: null
      }
    }
    {
      name: "fuzzel"
      source: "fuzzel"
      targets: {
        windows: null
        linux: "/home/jonld/.config/fuzzel"
        macos: null
      }
    }
    {
      name: "lazygit"
      source: "lazygit"
      targets: {
        windows: null
        linux: "/home/jonld/.config/lazygit"
        macos: null
      }
    }
    {
      name: "kanata"
      source: "kanata"
      targets: {
        windows: null
        linux: "/home/jonld/.config/kanata"
        macos: null
      }
    }
    {
      name: "zellij"
      source: "zellij"
      targets: {
        windows: null
        linux: "/home/jonld/.config/zellij"
        macos: null
      }
    }
    {
      name: "greetd"
      source: "greetd"
      targets: {
        windows: null
        linux: "/etc/greetd"
        macos: null
      }
    }
  ]
}