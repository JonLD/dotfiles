return {
    {
        "MagicDuck/grug-far.nvim",
        keys = {
            { "<leader>sr", false },
            {
                "<leader>R",
                function()
                    local grug = require("grug-far")
                    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                    grug.open({
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                        },
                    })
                end,
                mode = { "n", "v" },
                desc = "Search and Replace",
            },
        },
    },
    {
        "tiagovla/scope.nvim",
        config = function()
            require("scope").setup({})
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        keys = {
            { "<leader>e", false },
            { "<leader>E", false },
        },
    },
    {
        "psliwka/vim-smoothie",
        cond = function()
            if vim.g.neovide then
                return false
            else
                return true
            end
        end,
        keys = {
            {
                "<C-j>",
                '<cmd>call smoothie#do("\\<C-D>") <CR>',
            },
            {
                "<C-k>",
                '<cmd>call smoothie#do("\\<C-U>") <CR>',
            },
        },
    },
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = "LazyFile",
        opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>sxt", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sxT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
      { "<leader>st", false },
      { "<leader>sT", false },
    },
    },
    {
        "karb94/neoscroll.nvim",
        cond = false,
        opts = {
            mappings = { "zz", "zt", "zb" },
            -- easing = "quadratic",
        },
        keys = {
            {
                "<C-k>",
                function()
                    require("neoscroll").ctrl_u({ duration = 200 })
                end,
            },
            {
                "<C-j>",
                function()
                    require("neoscroll").ctrl_d({ duration = 200 })
                end,
            },
            -- {
            --     "<C-b>",
            --     function()
            --         require("neoscroll").ctrl_b({ duration = 450 })
            --     end,
            -- },
            -- {
            --     "<C-f>",
            --     function()
            --         require("neoscroll").ctrl_f({ duration = 450 })
            --     end,
            -- },
        },
    },
}
