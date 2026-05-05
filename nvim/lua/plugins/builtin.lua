local util = require("utils.util")

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        keys = {
            { "<leader>e", false },
            { "<leader>E", false },
        },
    },
    {
        "saghen/blink.cmp",
        cond = util.not_firenvim(),
        opts = {
            keymap = {
                ["<C-l>"] = { "select_and_accept" }
            },
        }
    },
    {
        "ahmedkhalf/project.nvim",
        cond = util.not_firenvim(),
        opts = {
            scope_chdir = "tab",
        },
    },
    {
        "folke/flash.nvim",
        lazy = true,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            require("nvim-treesitter.install").compilers = { "clang" }
        end,
    },
}
