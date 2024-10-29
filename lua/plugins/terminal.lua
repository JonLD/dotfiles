-- local lazygit_toggle = function()
--     local Terminal = require("toggleterm.terminal").Terminal
--     local lazygit = Terminal:new({
--         cmd = "lazygit",
--         hidden = true,
--         direction = "float",
--         float_opts = {
--             border = "none",
--             width = 100000,
--             height = 100000,
--             zindex = 200,
--         },
--         on_open = function(_)
--             vim.cmd("startinsert!")
--         end,
--         on_close = function(_) end,
--         count = 99,
--     })
--     lazygit:toggle()
-- end
--
return {
    {
        "akinsho/toggleterm.nvim",
        opts = {
            direction = "vertical",
            -- shell = "nu", -- Add your favourite shell here!
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
        },
        cmd = {
            "ToggleTerm",
            "TermExec",
            "ToggleTermToggleAll",
            "ToggleTermSendCurrentLine",
            "ToggleTermSendVisualLines",
            "ToggleTermSendVisualSelection",
        },
        keys = {
            {
                mode = {
                    "n",
                    "t",
                },
                "<C-\\>",
                "<cmd>ToggleTermToggleAll<CR>",
                desc = "Toggle Terminals",
            },
        },
    },
    -- {
    --     "akinsho/toggleterm.nvim",
    --     config = true,
    --     cmd = {
    --         "ToggleTerm",
    --     },
    --     keys = {
    --         "<C-_>",
    --         lazygit_toggle(),
    --         desc = "Terminal",
    --     },
    -- },
    {
        "ryanmsnyder/toggleterm-manager.nvim",
        config = true,
        keys = {
            {
                "<leader>ft",
                "<cmd>Telescope toggleterm_manager<CR>",
            },
            opts = {

            },
        },
    },
}
