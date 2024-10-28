-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

-- vim.keymap.del("n", "<leader>cF")
vim.keymap.del("n", "<C-w><C-d>")
vim.keymap.del("n", "<C-w>d")
vim.keymap.del("n", "<leader>-")
vim.keymap.del("n", "<leader>|")
vim.keymap.del("n", "<leader>K")

if vim.g.neovide then
    vim.keymap.del("n", "<C-j>")
    vim.keymap.del("n", "<C-k>")
    map("n", "<C-j>", "<C-d>")
    map("n", "<C-k>", "<C-u>")
end
map("n", "<C-f>", "<C-e>")
map("n", "<C-d>", "<C-y>")
map("n", "<leader>wj", "<C-w>j", { desc = "Move to window below" } )
map("n", "<leader>wk", "<C-w>k", { desc = "Move to window above" } )
map("n", "<leader>wh", "<C-w>h", { desc = "Move to window left" } )
map("n", "<leader>wl", "<C-w>l", { desc = "Move to window right" } )
map("n", "<tab>l", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<tab>h", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- vim.keymap.set("n", "<leader>cd", function()
--     -- when rename opens the prompt, this autocommand will trigger
--     -- it will "press" CTRL-F to enter the command-line window `:h cmdwin`
--     -- in this window I can use normal mode keybindings
--     local cmdId
--     cmdId = vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
--         callback = function()
--             local key = vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
--             vim.api.nvim_feedkeys(key, "c", false)
--             vim.api.nvim_feedkeys("0", "n", false)
--             -- autocmd was triggered and so we can remove the ID and return true to delete the autocmd
--             cmdId = nil
--             return true
--         end,
--     })
--     vim.lsp.buf.rename()
--     -- if LPS couldn't trigger rename on the symbol, clear the autocmd
--     vim.defer_fn(function()
--         -- the cmdId is not nil only if the LSP failed to rename
--         if cmdId then
--             vim.api.nvim_del_autocmd(cmdId)
--         end
--     end, 500)
-- end)

local DiffFormat = function()
    local hunks = require("gitsigns").get_hunks()
    local format = require("conform").format
    for i = #hunks, 1, -1 do
        local hunk = hunks[i]
        if hunk ~= nil and hunk.type ~= "delete" then
            local start = hunk.added.start
            local last = start + hunk.added.count
            -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
            local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
            local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
            format({ range = range })
        end
    end
end

require("which-key").add({
    "<leader>cF",
    function()
        DiffFormat()
    end,
    desc = "Format diff (hunks)",
})
