-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/lazyvim/lazyvim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false
local opt = vim.opt
vim.diagnostic.config({ underline = true, virtual_text = false })
opt.spelloptions = "camel"
opt.spell = true
opt.spelllang = "en_gb"
opt.shiftwidth = 4 -- Size of an indent
opt.wrap = true
opt.tabstop = 4
-- opt.smartindent = true
opt.expandtab = true
opt.colorcolumn = "-20,-40,-60"
opt.tw = 140
vim.lsp.set_log_level("debug")
vim.cmd("let c_syntax_for_h = 1")
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

-- LazyVim.terminal.setup("nu") -- Add your shell here
-- Configure vim shell options for your shell here
-- vim.cmd("let shell = 'nu'")
-- vim.cmd("let shellcmdflag = '-c'")
-- vim.cmd("let shellquote = ''")
-- vim.cmd("let shellquote = ''")
