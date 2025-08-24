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

let  fg = "#D6D4D4"
let  bg = "#1E1E1E"
let  alt_fg = "#a4a4a4"
let  alt_bg = "#252525"
let  line = "#3e3e3e"
let  dark_gray = "#404040"
let  gray = "#808080"
let  context = "#606060"
let  light_gray = "#cccccc"
let  menu_bg = "#202123"
let  red = "#D16969"
let  blue = "#569CD6"
let  vivid_blue = "#4FC1FF"
let  light_blue = "#9CDCFE"
let  green = "#6A9955"
let  light_green = "#B5CEA8"
let  cyan = "#4EC9B0"
let  orange = "#CE9178"
let  yellow = "#DCDCAA"
let  yellow_orange = "#D7BA7D"
let  purple = "#C586C0"
let  magenta = "#D16D9E"
let  cursor_fg = "#515052"
let  cursor_bg = "#AEAFAD"
let  sign_add = "#587c0c"
let  sign_change = "#0c7d9d"
let  sign_delete = "#94151b"
let  sign_add_alt = "#73C991"
let  sign_change_alt = "#CCA700"
let  error = "#F44747"
let  warn = "#ff8800"
let  info = "#FFCC66"
let  hint = "#4bc1fe"
let  error_bg = "#31262d"
let  warn_bg = "#32302f"
let  info_bg = "#1e3135"
let  hint_bg = "#22323f"
let  fold_bg = "#212E3A"
let  reference = "#363636"
let  success_green = "#14C50B"
let  folder_blue = "#42A5F5"
let  ui_blue = "#264F78"
let  ui2_blue = "#042E48"
let  ui3_blue = "#0195F7"
let  ui4_blue = "#75BEFF"
let  ui5_blue = "#083C5A"
let  ui_orange = "#E8AB53"
let  ui2_orange = "#613214"
let  ui_purple = "#B180D7"

$env.config.color_config = {
    command: $purple
    literal: $blue
    external: $red
}

let darkplus_theme = {
    separator: $fg
    header: $sign_change_alt
    date: $blue
    filesize: $blue
    row_index: $blue
    bool: $blue
    int: $blue
    duration: $fg
    range: $blue
    float: $blue
    string: $orange
    nothing: $blue
    binary: $cyan
    cellpath: $blue
    hints: $alt_fg
    modified: $red

    # but i like the regular white on red for parse errors
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b }
    shape_bool: $blue
    shape_int:  $red
    shape_float: $red
    shape_range: { fg: $red attr: b }
    shape_internalcall: $purple
    shape_external: $ui_orange
    shape_externalarg: { fg: $blue attr: b }
    shape_literal: $red
    shape_operator:  $red
    shape_signature: { fg:$red attr: b }
    shape_string:  $blue
    shape_filepath:  $red
    shape_globpattern: { fg: $blue attr: b }
    shape_variable: $blue
    shape_flag: { fg: $blue attr: b }
    shape_custom: $ui_orange
}

# Gruvbox color palette
let gruvbox_bg = "#1d2021"
let gruvbox_fg = "#ebdbb2"
let gruvbox_red = "#fb4934"
let gruvbox_green = "#b8bb26"
let gruvbox_yellow = "#fabd2f"
let gruvbox_blue = "#83a598"
let gruvbox_purple = "#d3869b"
let gruvbox_aqua = "#8ec07c"
let gruvbox_orange = "#fe8019"
let gruvbox_gray = "#a89984"
let gruvbox_dark_gray = "#928374"

let gruvbox_theme = {
    separator: $gruvbox_fg
    header: $gruvbox_yellow
    date: $gruvbox_blue
    filesize: $gruvbox_aqua
    row_index: $gruvbox_blue
    bool: $gruvbox_purple
    int: $gruvbox_red
    duration: $gruvbox_fg
    range: $gruvbox_orange
    float: $gruvbox_red
    string: $gruvbox_green
    nothing: $gruvbox_blue
    binary: $gruvbox_aqua
    cellpath: $gruvbox_blue
    hints: $gruvbox_gray
    modified: $gruvbox_red

    # Parse errors
    shape_garbage: { fg: $gruvbox_bg bg: $gruvbox_red attr: b }
    shape_bool: $gruvbox_purple
    shape_int: $gruvbox_red
    shape_float: $gruvbox_red
    shape_range: { fg: $gruvbox_orange attr: b }
    shape_internalcall: $gruvbox_purple
    shape_external: $gruvbox_orange
    shape_externalarg: { fg: $gruvbox_blue attr: b }
    shape_literal: $gruvbox_red
    shape_operator: $gruvbox_red
    shape_signature: { fg: $gruvbox_red attr: b }
    shape_string: $gruvbox_green
    shape_filepath: $gruvbox_aqua
    shape_globpattern: { fg: $gruvbox_blue attr: b }
    shape_variable: $gruvbox_blue
    shape_flag: { fg: $gruvbox_yellow attr: b }
    shape_custom: $gruvbox_orange
}

# Theme selection flag
let use_gruvbox = true

# Apply selected theme
if $use_gruvbox {
    $env.LS_COLORS = (vivid generate gruvbox-dark)
    $env.config.color_config = $gruvbox_theme
} else {
    $env.LS_COLORS = (vivid generate zenburn)
    $env.config.color_config = $darkplus_theme
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
       text: $ui3_blue
       selected_text: $sign_change_alt
       description_text: $ui3_blue
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

alias serena = uv run --directory C:\serena
alias claude-add-serena = claude mcp add serena -- uv run --directory C:\mcp-servers\serena serena-mcp-server --context ide-assistant --project $env.pwd
alias gen_cc = nu C:\dev\generate-compile-commands\generate_compile_commands.nu

# UI
$env.config.table.mode = 'rounded'
$env.config.show_banner = false
$env.config.edit_mode = "vi"

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

# avoid same PROMPT_INDICATOR
$env.PROMPT_INDICATOR = { "" }
$env.PROMPT_INDICATOR_VI_INSERT = { ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = { "〉" }
$env.PROMPT_MULTILINE_INDICATOR = { "::: " }

source ~/.zoxide.nu
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

