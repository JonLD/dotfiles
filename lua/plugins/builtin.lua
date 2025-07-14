local util = require("utils.util")

return {
    {
        "folke/snacks.nvim",
        keys = {
            { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
            { "<leader>sb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
            { "<leader>sf", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        },
        opts = {
            picker = {
                win = {
                    input = {
                        keys = {
                            ["<C-l>"] = { "confirm", mode = { "n", "i" } },
                        },
                    },
                }
            },
        }
    },
    {
        "saghen/blink.cmp",
        opts = {
            keymap = {
                ["<C-l>"] = { "select_and_accept" }
            },
        }
    },
    {
        "nvim-lualine/lualine.nvim",
        cond = util.not_firenvim(),
    },
    {
        "lewis6991/gitsigns.nvim",
        cond = util.not_firenvim(),
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
    { "folke/noice.nvim", cond = util.not_firenvim(), enabled = true },
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<leader>cr", group = "Refactor", icon = { icon = " ", color = "orange" } },
            },
        },
    },
    {
        "ThePrimeagen/refactoring.nvim",
        cond = util.not_firenvim(),
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            { "<leader>cr", "", desc = "+refactor", mode = { "n", "v" } },
            {
                "<leader>cri",
                function()
                    require("refactoring").refactor("Inline Variable")
                end,
                mode = { "n", "v" },
                desc = "Inline Variable",
            },
            {
                "<leader>crb",
                function()
                    require("refactoring").refactor("Extract Block")
                end,
                desc = "Extract Block",
            },
            {
                "<leader>crf",
                function()
                    require("refactoring").refactor("Extract Block To File")
                end,
                desc = "Extract Block To File",
            },
            {
                "<leader>crP",
                function()
                    require("refactoring").debug.printf({ below = false })
                end,
                desc = "Debug Print",
            },
            {
                "<leader>crp",
                function()
                    require("refactoring").debug.print_var({ normal = true })
                end,
                desc = "Debug Print Variable",
            },
            {
                "<leader>crc",
                function()
                    require("refactoring").debug.cleanup({})
                end,
                desc = "Debug Cleanup",
            },
            {
                "<leader>crf",
                function()
                    require("refactoring").refactor("Extract Function")
                end,
                mode = "v",
                desc = "Extract Function",
            },
            {
                "<leader>crF",
                function()
                    require("refactoring").refactor("Extract Function To File")
                end,
                mode = "v",
                desc = "Extract Function To File",
            },
            {
                "<leader>crx",
                function()
                    require("refactoring").refactor("Extract Variable")
                end,
                mode = "v",
                desc = "Extract Variable",
            },
        },
        opts = {
            prompt_func_return_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            prompt_func_param_type = {
                go = false,
                java = false,
                cpp = false,
                c = false,
                h = false,
                hpp = false,
                cxx = false,
            },
            printf_statements = {},
            print_var_statements = {},
            show_success_message = true, -- shows a message with information about the refactor on success
            -- i.e. [Refactor] Inlined 3 variable occurrences
        },
        config = function(_, opts)
            require("refactoring").setup(opts)
        end,
    },
}
