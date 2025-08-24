# env.nu
#
# Installed by:
# version = "0.105.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.
zoxide init nushell | save -f ~/.zoxide.nu
let starship_config_path = ($nu.config-path | path dirname | path join "starship" "starship.toml")
$env.STARSHIP_CONFIG = $starship_config_path
$env.EDITOR = "nvim"
$env.FZF_DEFAULT_OPTS = "--bind 'ctrl-l:accept'"
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME | path join ".cargo" "bin"))
