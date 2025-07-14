-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set
local delete = vim.keymap.del

-- delete("n", "<leader>cF")
delete("n", "<C-w><C-d>")
delete("n", "<C-w>d")
-- delete("n", "<leader>-")
-- delete("n", "<leader>|")
-- delete("n", "<leader>K")
delete("n", "<C-w><space>")
delete("n", "<leader>bD")

delete("n", "<C-j>")
delete("n", "<C-k>")
map("n", "<C-j>", "<C-d>")
map("n", "<C-k>", "<C-u>")
map("i", "<C-v>", "<C-r>+")
map("n", "<C-f>", "<C-e>")
map("n", "<C-d>", "<C-y>")
map("n", "<leader>wj", "<C-w>j", { desc = "Move to window below" })
map("n", "<leader>wk", "<C-w>k", { desc = "Move to window above" })
map("n", "<leader>wh", "<C-w>h", { desc = "Move to window left" })
map("n", "<leader>wl", "<C-w>l", { desc = "Move to window right" })
map("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>h", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader>d", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bd", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
map("n", "<C-_>", "<cmd>ToggleTerm<CR>")
map("n", "<C-/>", "<cmd>ToggleTerm<CR>")

local function insertNewline()
    local line = vim.api.nvim_get_current_line()
    local pos = vim.api.nvim_win_get_cursor(0)
    local col = pos[2]
    local function countTillWhitespace(direction)
        local count = 0
        while string.sub(line, col, col) ~= " " do
            count = count + 1
            if count >= 120 then
                return nil
            end
            col = col + direction
            -- print(col)
        end
        return count, col
    end
    local countTillPrevWhitespace, prevCol = countTillWhitespace(1)
    local countTillNextWhitespace, nextCol = countTillWhitespace(-1)
    local insertAt
    if countTillPrevWhitespace < countTillNextWhitespace then
        insertAt = prevCol
    else
        insertAt = nextCol
    end
    local currentLineNum = pos[1]
    vim.api.nvim_buf_set_lines(0, currentLineNum - 1, currentLineNum, false, { line:sub(0, insertAt) })
    vim.api.nvim_buf_set_lines(0, currentLineNum, currentLineNum, false, { line:sub(insertAt + 1) })
    -- if countTillPrevWhitespace == nil then
    --     vim.api.nvim_command("normal i<CR><ESC>")
    -- elseif countTillPrevWhitespace < countTillNextWhitespace then
    --     vim.api.nvim_command("normal i<CR><ESC>")
    -- else
    --     vim.api.nvim_command("normal a<CR><ESC>")
    -- end
end

map("n", "gj", insertNewline, { desc = "" })

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

require("which-key").add({
    "<leader>r",
    vim.lsp.buf.rename,
    desc = "Rename",
    icon = { icon = "󰑕 ", color = "orange" },
})
