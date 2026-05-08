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
      source: "CLAUDE.md"
      targets: {
        windows: ".claude/CLAUDE.md"
        linux: ".claude/CLAUDE.md"
        macos: null
      }
    }
    {
      name: "ghostty"
      source: "ghostty"
      targets: {
        windows: null
        linux: ".config/ghostty"
        macos: null
      }
    }
    {
      name: "hypr"
      source: "hypr"
      targets: {
        windows: null
        linux: ".config/hypr"
        macos: null
      }
    }
    {
      name: "mako"
      source: "mako"
      targets: {
        windows: null
        linux: ".config/mako"
        macos: null
      }
    }
    {
      name: "waybar"
      source: "waybar"
      targets: {
        windows: null
        linux: ".config/waybar"
        macos: null
      }
    }
    {
      name: "tmux"
      source: "tmux"
      targets: {
        windows: null
        linux: ".config/tmux"
        macos: null
      }
    }
    {
      name: "tmux-sessionizer"
      source: "tmux-sessionizer"
      targets: {
        windows: null
        linux: ".config/tmux-sessionizer"
        macos: null
      }
    }
    {
      name: "fuzzel"
      source: "fuzzel"
      targets: {
        windows: null
        linux: ".config/fuzzel"
        macos: null
      }
    }
    {
      name: "lazygit"
      source: "lazygit"
      targets: {
        windows: "AppData/Roaming/lazygit"
        linux: ".config/lazygit"
        macos: null
      }
    }
    {
      name: "kanata"
      source: "kanata"
      targets: {
        windows: null
        linux: ".config/kanata"
        macos: null
      }
    }
    {
      name: "zellij"
      source: "zellij"
      targets: {
        windows: null
        linux: ".config/zellij"
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
