local gs = require("gitsigns")
return {
    "lewis6991/gitsigns.nvim",
    keys = {
        {
            "<leader>gj",
            function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    gs.nav_hunk("next")
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
                    gs.nav_hunk("prev")
                end
            end,
            "Prev Hunk",
        },
        {
            "<leader>gJ",
            function()
                gs.nav_hunk("last")
            end,
            "Last Hunk",
        },
        {
            "<leader>gK",
            function()
                gs.nav_hunk("first")
            end,
            "First Hunk",
        },
        { "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk" },
        { "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk" },
        { "<leader>gS", gs.stage_buffer, "Stage Buffer" },
        { "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk" },
        { "<leader>gR", gs.reset_buffer, "Reset Buffer" },
        { "<leader>gp", gs.preview_hunk_inline, "Preview Hunk Inline" },
        {
            "<leader>ghb",
            function()
                gs.blame_line({ full = true })
            end,
            "Blame Line",
        },
        {
            "<leader>ghB",
            function()
                gs.blame()
            end,
            "Blame Buffer",
        },
    },
}
