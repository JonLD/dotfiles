local c = {
  fg = "#D4D4D4",
  bg = "#1E1E1E",
  alt_fg = "#a4a4a4",
  alt_bg = "#252525",
  line = "#3e3e3e",
  dark_gray = "#404040",
  gray = "#808080",
  context = "#606060",
  light_gray = "#cccccc",
  menu_bg = "#202123",
  red = "#D16969",
  blue = "#569CD6",
  vivid_blue = "#4FC1FF",
  light_blue = "#9CDCFE",
  green = "#6A9955",
  light_green = "#B5CEA8",
  cyan = "#4EC9B0",
  orange = "#CE9178",
  yellow = "#DCDCAA",
  yellow_orange = "#D7BA7D",
  purple = "#C586C0",
  magenta = "#D16D9E",
  cursor_fg = "#515052",
  cursor_bg = "#AEAFAD",
  sign_add = "#587c0c",
  sign_change = "#0c7d9d",
  sign_delete = "#94151b",
  sign_add_alt = "#73C991",
  sign_change_alt = "#CCA700",
  error = "#F44747",
  warn = "#ff8800",
  info = "#FFCC66",
  hint = "#4bc1fe",
  error_bg = "#31262d",
  warn_bg = "#32302f",
  info_bg = "#1e3135",
  hint_bg = "#22323f",
  fold_bg = "#212E3A",
  reference = "#363636",
  success_green = "#14C50B",
  folder_blue = "#42A5F5",
  ui_blue = "#264F78",
  ui2_blue = "#042E48",
  ui3_blue = "#0195F7",
  ui4_blue = "#75BEFF",
  ui5_blue = "#083C5A",
  ui_orange = "#E8AB53",
  ui2_orange = "#613214",
  ui_purple = "#B180D7",
}

local hl = vim.api.nvim_set_hl
local function set_custom_highlights()
    hl(0, "@comment", { fg = c.green, bg = 'NONE', })
    hl(0, "@tag.attribute", { fg = c.light_blue, bg = 'NONE', })
    hl(0, "markdownBoldItalic", { fg = c.yellow, bg = 'NONE', bold = true, })
    hl(0, "LspCodeLens", { fg = c.context, bg = 'NONE', })
    hl(0, "LspCodeLensSeparator", { fg = c.context, bg = 'NONE', })
    hl(0, "NvimTreeOpenedFolderName", { fg = c.folder_blue, bg = 'NONE', bold = true, })
    hl(0, "NvimTreeEmptyFolderName", { fg = c.gray, bg = 'NONE', })
    hl(0, "NvimTreeGitIgnored", { fg = c.gray, bg = 'NONE', })
    hl(0, "LirEmptyDirText", { fg = c.gray, bg = 'NONE', })
    hl(0, "SnacksPicker", { fg = c.fg, bg = c.bg })
    hl(0, "SnacksPickerBorder", { fg = c.bg, bg = c.bg })
    hl(0, "SnacksPickerInput", {  fg = c.fg, bg = c.bg })
    hl(0, "SnacksPickerBoxTitle", { fg = c.fg, bg = c.bg })
    hl(0, "SnacksPickerBoxBorder", { fg = c.bg, bg = c.bg })
    hl(0, "SnacksPickerPreviewTitle", { fg = c.fg, bg = c.bg })
    hl(0, "SnacksPickerInputBorder", { fg = c.fg, bg = c.bg })
    hl(0, "@lsp.mod.callable.rust", { link = "@function" })
    hl(0, "@lsp.mod.controlFlow.rust", { link = "@lsp.typemod.keyword.controlFlow.rust" })

    -- Popup backgrounds
    hl(0, "Pmenu", { fg = c.fg, bg = c.menu_bg })
    hl(0, "PmenuSel", { fg = c.fg, bg = c.alt_bg })
    hl(0, "PmenuSbar", { bg = c.dark_gray })
    hl(0, "PmenuThumb", { bg = c.gray })
    hl(0, "NormalFloat", { fg = c.fg, bg = c.menu_bg })
    hl(0, "FloatBorder", { fg = c.gray, bg = c.menu_bg })
end

vim.api.nvim_create_autocmd("ColorScheme",
    {
        pattern = "*",
        callback = function()
            set_custom_highlights()
        end,
    })

return {
    {
      "ellisonleao/gruvbox.nvim",
    },
    {
        "YaQia/darkplus.nvim",
    },
    {
        "Mofiqul/vscode.nvim",
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "gruvbox",
        },
    },
    {
        "folke/tokyonight.nvim",
        enabled = true,
    },
}
