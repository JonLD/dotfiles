-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/lazyvim/lazyvim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false
vim.env.CC = "clang"
local opt = vim.opt
vim.diagnostic.config({ underline = true, virtual_text = false })
opt.spelloptions = "camel"
opt.spell = true
opt.spelllang = "en_gb"
opt.shiftwidth = 4 -- Size of an indent
opt.wrap = false
opt.tabstop = 4
opt.smartindent = true
opt.expandtab = true
opt.colorcolumn = "80,100,120"
opt.tw = 120
vim.cmd("let c_syntax_for_h = 1")
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.g.lazyvim_python_lsp = "basedpyright"
if vim.fn.has("win32") == 1 and vim.fn.has("wsl") == 0 then
    vim.env.PATH = "C:\\Python312;" .. vim.env.PATH
end
vim.g.root_spec = { { ".git", "lua" }, "cwd" }
opt.guifont = "JetBrainsMonoNL NF:h10:Consolas"

-- Configure vim shell options for your shell here
vim.o.shell = 'nu'
vim.o.shellcmdflag = '-c'
vim.o.shellquote = ""
vim.o.shellxquote = ""
if vim.fn.has("wsl") == 1 then
    vim.opt.clipboard = "unnamedplus"

    vim.g.clipboard = {
        name = "win32yank",
        copy = {
            ["+"] = { "win32yank.exe", "-i", "--crlf" },
            ["*"] = { "win32yank.exe", "-i", "--crlf" },
        },
        paste = {
            ["+"] = { "win32yank.exe", "-o", "--lf" },
            ["*"] = { "win32yank.exe", "-o", "--lf" },
        },
        cache_enabled = 1,
    }
elseif vim.fn.has("win32") == 1 then
    vim.opt.clipboard = "unnamedplus"
    local win32yank = vim.fn.fnamemodify(vim.v.progpath, ":h") .. "\\win32yank.exe"
    vim.g.clipboard = {
        name = "win32yank",
        copy = {
            ["+"] = { win32yank, "-i", "--crlf" },
            ["*"] = { win32yank, "-i", "--crlf" },
        },
        paste = {
            ["+"] = { win32yank, "-o", "--lf" },
            ["*"] = { win32yank, "-o", "--lf" },
        },
        cache_enabled = 1,
    }
end
