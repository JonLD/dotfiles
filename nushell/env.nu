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
$env.EDITOR = "nvim"
$env.FZF_DEFAULT_OPTS = "--bind 'ctrl-l:accept'"
# PATH setup (before tools that depend on it)
$env.PATH = ($env.PATH
    | split row (char esep)
    | prepend ($env.HOME | path join ".cargo" "bin")
    | prepend ($env.HOME | path join ".local" "bin")
    | prepend ($env.HOME | path join ".nvm" "versions" "node" "v24.11.1" "bin")
    | prepend "/opt/nvim"
)

# Local env vars are loaded from vendor/autoload/env.local.nu (gitignored)
zoxide init nushell | save -f ~/.zoxide.nu
# Load local env vars (gitignored)
const local_env = ($nu.default-config-dir | path join "vendor" "autoload" "env.local.nu")
source-env $local_env
