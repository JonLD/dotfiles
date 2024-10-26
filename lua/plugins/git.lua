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
            "Next Hunk",
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
            "Prev Hunk",
        },
        {
            "<leader>gJ",
            function()
                require("gitsigns").nav_hunk("last")
            end,
            "Last Hunk",
        },
        {
            "<leader>gK",
            function()
                require("gitsigns").nav_hunk("first")
            end,
            "First Hunk",
        },
        { "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk" },
        { "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk" },
        { "<leader>gS", "lua require('gitsigns').stage_buffer<CR>", "Stage Buffer" },
        { "<leader>gu", "lua require('gitsigns').undo_stage_hunk<CR>", "Undo Stage Hunk" },
        { "<leader>gR", "lua require('gitsigns').reset_buffer<CR>", "Reset Buffer" },
        { "<leader>gp", "lua require('gitsigns').preview_hunk_inline<CR>", "Preview Hunk Inline" },
        {
            "<leader>ghb",
            function()
                require("gitsigns").blame_line({ full = true })
            end,
            "Blame Line",
        },
        {
            "<leader>ghB",
            function()
                require("gitsigns").blame()
            end,
            "Blame Buffer",
        },
    },
}
