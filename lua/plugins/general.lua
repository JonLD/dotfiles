return {
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    },
    {
        "chrisgrieser/nvim-spider",
        lazy = true,
        keys = {
            {
                "<C-e>",
                "<cmd>lua require('spider').motion('e')<CR>",
                mode = { "n", "o", "x" },
            },
            {
                "<C-b>",
                "<cmd>lua require('spider').motion('b')<CR>",
                mode = { "n", "o", "x" },
            },
            {
                "<C-w>",
                "<cmd>lua require('spider').motion('w')<CR>",
                mode = { "n", "o", "x" },
            },
        },
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
    },
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "clangd",
                "black",
                "pylint",
                "lua-language-server",
            },
        },
    },
    {
        "zdcthomas/yop.nvim",
        config = function()
            require("yop").op_map({ "n", "v" }, "<space>t", function(lines)
                if #lines > 1 then -- Multiple lines can't be searched for
                    return
                end
                require("telescope").extensions.live_grep_args.live_grep_args({ default_text = lines[1] })
            end)
            require("yop").op_map({ "n", "v" }, "<space>sS", function(lines)
                if #lines > 1 then -- Multiple lines can't be searched for
                    return
                end
                require("spectre").open_file_search({})
            end)
        end,
    },
    {
        "gbprod/yanky.nvim",
        keys = {
            { "<C-n>", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
            { "<C-P>", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
        },
    },
    {
        "psliwka/vim-smoothie",
        config = function()
            require("vim-smoothie").setup()
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
        enabled = true,
    },
    {
        "karb94/neoscroll.nvim",
        enabled = false,
        config = function()
            require("neoscroll").setup({
                mappings = { "zz", "zt", "zb" },
                easing = "quadratic",
            })
        end,
        keys = {
            {
                "<C-k>",
                function()
                    require("neoscroll").ctrl_u({ duration = 20 })
                end,
            },
            {
                "<C-j>",
                function()
                    require("neoscroll").ctrl_d({ duration = 20 })
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
    { "rcarriga/nvim-notify", enabled = false },
    { "folke/noice.nvim", enabled = false },
    {
        "max397574/better-escape.nvim",
        config = function()
            require("better_escape").setup({
                mappings = {
                    i = {
                        k = {
                            -- These can all also be functions
                            j = "<Esc>",
                        },
                    },
                    c = {
                        k = {
                            j = "<Esc>",
                        },
                    },
                    t = {
                        k = {
                            j = "<C-\\><C-n>",
                        },
                    },
                    v = {
                        k = {
                            j = "<Esc>",
                        },
                    },
                    s = {
                        k = {
                            j = "<Esc>",
                        },
                    },
                },
            })
        end,
    },
}
