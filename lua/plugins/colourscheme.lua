local c = {
  gray = "#808080",
  context = "#606060",
  light_blue = "#9CDCFE",
  green = "#6A9955",
  yellow = "#DCDCAA",
  info = "#FFCC66",
  folder_blue = "#42A5F5",
}

local hl = vim.api.nvim_set_hl
local function set_custom_highlights()
    hl(0, "@comment", { fg = c.green, bg = 'NONE', })
    hl(0, "@tag.attribute", { fg = c.light_blue, bg = 'NONE', })
    hl(0, "markdownBoldItalic", { fg = c.yellow, bg = 'NONE', bold = true, })
    hl(0, "LspCodeLens", { fg = c.context, bg = 'NONE', })
    hl(0, "LspCodeLensSeparator", { fg = c.context, bg = 'NONE', })
    hl(0, "TelescopeMatching", { fg = c.info, bg = 'NONE', bold = true, })
    hl(0, "NvimTreeOpenedFolderName", { fg = c.folder_blue, bg = 'NONE', bold = true, })
    hl(0, "NvimTreeEmptyFolderName", { fg = c.gray, bg = 'NONE', })
    hl(0, "NvimTreeGitIgnored", { fg = c.gray, bg = 'NONE', })
    hl(0, "LirEmptyDirText", { fg = c.gray, bg = 'NONE', })
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
        "YaQia/darkplus.nvim",
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "darkplus",
        },
    },
    {
        "folke/tokyonight.nvim",
        enabled = true,
    },
}
