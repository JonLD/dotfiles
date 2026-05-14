# config.nu
#
# Installed by:
# version = "0.105.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

$env.config.buffer_editor = "nvim"

# Gruvbox color palette
const gruvbox_bg = "#1d2021"
const gruvbox_fg = "#ebdbb2"
const gruvbox_red = "#fb4934"
const gruvbox_green = "#b8bb26"
const gruvbox_yellow = "#fabd2f"
const gruvbox_blue = "#83a598"
const gruvbox_purple = "#d3869b"
const gruvbox_aqua = "#8ec07c"
const gruvbox_orange = "#fe8019"
const gruvbox_gray = "#a89984"
const gruvbox_dark_gray = "#928374"

$env.config.color_config = {
    separator:  $gruvbox_dark_gray
    header:     $gruvbox_yellow
    date:       $gruvbox_blue
    filesize:   $gruvbox_aqua
    row_index:  $gruvbox_dark_gray
    bool:       $gruvbox_purple
    int:        $gruvbox_red
    float:      $gruvbox_red
    duration:   $gruvbox_fg
    range:      $gruvbox_orange
    string:     $gruvbox_green
    nothing:    $gruvbox_dark_gray
    binary:     $gruvbox_aqua
    cellpath:   $gruvbox_blue
    hints:      $gruvbox_dark_gray
    modified:   $gruvbox_red

    shape_garbage:      { fg: $gruvbox_bg bg: $gruvbox_red attr: b }
    shape_bool:         $gruvbox_purple
    shape_int:          $gruvbox_red
    shape_float:        $gruvbox_red
    shape_range:        { fg: $gruvbox_orange attr: b }
    shape_internalcall: $gruvbox_green
    shape_external:     $gruvbox_yellow
    shape_externalarg:  $gruvbox_fg
    shape_literal:      $gruvbox_red
    shape_operator:     $gruvbox_orange
    shape_signature:    { fg: $gruvbox_yellow attr: b }
    shape_string:       $gruvbox_green
    shape_filepath:     $gruvbox_aqua
    shape_globpattern:  { fg: $gruvbox_aqua attr: b }
    shape_variable:     $gruvbox_blue
    shape_flag:         { fg: $gruvbox_orange attr: b }
    shape_custom:       $gruvbox_orange
}

$env.config.cursor_shape = {
    vi_insert: line
    vi_normal: block
    emacs: line
}

$env.config.menus = [{
   name: history_menu
   only_buffer_difference: false
   marker: "? "
   type: {
       layout: list
       page_size: 10
   }
   style: {
       text: $gruvbox_blue
       selected_text: $gruvbox_yellow
       description_text: $gruvbox_blue
   }
}]

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

alias ka = kanata --cfg ~/dotfiles/kanata/kanata.kbd
alias ccon = claude --continue
alias nd = nu ~/dotfiles/nudot/nudot.nu
alias w = where.exe
alias qb = job spawn {qutebrowser | ignore}
alias bambu = job spawn {bambu-studio | ignore}
alias vim = nvim
alias v = nvim
alias ld = ls -d
alias ll = ls -l
alias la = ls -a
alias g = git
alias lg = lazygit
alias fuck = do { let cmd = (thefuck (history | last 1 | get command.0)); nu -c $cmd }

# UI
$env.config.table.mode = 'rounded'
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.completions.algorithm = "fuzzy"

# Keybindings - disable Ctrl-Space to avoid conflict with tmux prefix
$env.config.keybindings = [
    {
        name: disable_ctrl_space
        modifier: control
        keycode: space
        mode: [emacs, vi_normal, vi_insert]
        event: { send: none }
    }
]


$env.PROMPT_COMMAND = {||
    let dir = ($env.PWD | str replace $nu.home-dir "~")
    let hostname = (sys host | get hostname)
    let git_segment = (try {
        let branch = (^git --no-optional-locks branch --show-current | complete)
        if $branch.exit_code == 0 and ($branch.stdout | str trim | is-not-empty) {
            $"  (ansi { fg: $gruvbox_yellow }) ($branch.stdout | str trim) (ansi reset)"
        } else { "" }
    } catch { "" })
    $"(ansi { fg: $gruvbox_blue })($dir)(ansi reset)($git_segment) (ansi { fg: $gruvbox_aqua })($hostname)(ansi reset)\n"
}
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = $"(ansi { fg: $gruvbox_green })❯ (ansi reset)"
$env.PROMPT_INDICATOR_VI_NORMAL = $"(ansi { fg: $gruvbox_blue })◆ (ansi reset)"
$env.PROMPT_MULTILINE_INDICATOR = $"(ansi { fg: $gruvbox_gray })∙∙∙(ansi reset) "

const zoxide_init_path = ($nu.home-dir | path join ".zoxide.nu")
const zoxide_init = if ($zoxide_init_path | path exists) { $zoxide_init_path } else { null }
source $zoxide_init

const custom_completions_dir = ($nu.default-config-dir | path join "custom-completions")
source ($custom_completions_dir | path join "cargo-completions.nu")
source ($custom_completions_dir | path join "npm-completions.nu")
source ($custom_completions_dir | path join "poetry-completions.nu")
source ($custom_completions_dir | path join "uv-completions.nu")
source ($custom_completions_dir | path join "ssh-completions.nu")
source ($custom_completions_dir | path join "git-completions.nu")
source ($custom_completions_dir | path join "make-completions.nu")
source ($custom_completions_dir | path join "zoxide-completions.nu")

const scripts_dir = ($nu.default-config-dir | path join "scripts")
source ($scripts_dir | path join "git-worktree.nu")
