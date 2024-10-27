return {
    { "tiagovla/scope.nvim",
        config = function ()
            require("scope").setup({})
        end
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
