return {
    {
        "nanotee/zoxide.vim",
        cmd = {
            "Z",
            "Lz",
            "Tz",
            "Zi",
            "Lzi",
            "Tzi",
        },
    },
    {
        "NMAC427/guess-indent.nvim",
        opts = {
            auto_cmd = true,
        },
    },
    { "MunifTanjim/nui.nvim" },
    {
        "norcalli/nvim-colorizer.lua",
        enabled = false,
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
        "gbprod/yanky.nvim",
        keys = {
            { "<C-n>", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
            { "<C-P>", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
        },
    },
    {
        "max397574/better-escape.nvim",
        opts = {
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
        },
    },
}
