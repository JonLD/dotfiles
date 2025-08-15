# nudot configuration file
# This file is automatically managed by nudot, but can be manually edited
# You can add paths for other operating systems before switching to them

export def get-dotfiles-config [] {
  [
    {
      name: "nushell"
      source: "nushell"
      targets: {
        windows: ($nu.home-path | path join "AppData" "Roaming" "nushell")
        linux: null
        macos: null
      }
    }
    {
      name: "nvim"
      source: "nvim"
      targets: {
        windows: ($nu.home-path | path join "AppData" "Local" "nvim")
        linux: null
        macos: null
      }
    }
    {
      name: "qutebrowser"
      source: "qutebrowser"
      targets: {
        windows: ($nu.home-path | path join "AppData" "Roaming" "qutebrowser")
        linux: null
        macos: null
      }
    }
  ]
}