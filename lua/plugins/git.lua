return {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    keys = {
        {
            "<leader>gj",
            function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    require("gitsigns").nav_hunk("next")
                end
            end,
            desc = "Next Hunk",
        },
        {
            "<leader>gk",
            function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    require("gitsigns").nav_hunk("prev")
                end
            end,
            desc = "Prev Hunk",
        },
        {
            "<leader>gJ",
            function()
                require("gitsigns").nav_hunk("last")
            end,
            desc = "Last Hunk",
        },
        {
            "<leader>gK",
            function()
                require("gitsigns").nav_hunk("first")
            end,
            desc = "First Hunk",
        },
        { "<leader>gs", ":Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
        { "<leader>gr", ":Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
        { "<leader>gS", "lua require('gitsigns').stage_buffer<CR>", desc = "Stage Buffer" },
        { "<leader>gu", "lua require('gitsigns').undo_stage_hunk<CR>", desc = "Undo Stage Hunk" },
        { "<leader>gR", "lua require('gitsigns').reset_buffer<CR>", desc = "Reset Buffer" },
        { "<leader>gp", "lua require('gitsigns').preview_hunk_inline<CR>", desc = "Preview Hunk Inline" },
        {
            "<leader>ghb",
            function()
                require("gitsigns").blame_line({ full = true })
            end,
            desc = "Blame Line",
        },
        {
            "<leader>ghB",
            function()
                require("gitsigns").blame()
            end,
            desc = "Blame Buffer",
        },
    },
}
