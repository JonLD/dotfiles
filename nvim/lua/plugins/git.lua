require("which-key").add({
    "<leader>gG",
    function()
        Snacks.terminal({ "gitui" }, {win = { position = "float" } })
    end,
    desc = "GitUi",
})

return {
    "lewis6991/gitsigns.nvim",
    version = "v1.0.0",
    lazy = true,
    keys = {
        {
            "<leader>gj",
            function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    require("gitsigns").nav_hunk("next", {navigation_message = false})
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
                    require("gitsigns").nav_hunk("prev", {navigation_message = false})
                end
            end,
            desc = "Prev Hunk",
        },
        {
            "<leader>gJ",
            function()
                require("gitsigns").nav_hunk("last", {navigation_message = false})
            end,
            desc = "Last Hunk",
        },
        {
            "<leader>gK",
            function()
                require("gitsigns").nav_hunk("first", {navigation_message = false})
            end,
            desc = "First Hunk",
        },
        { "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
        { "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
        { "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", desc = "Stage Buffer" },
        { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo Stage Hunk" },
        { "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset Buffer" },
        { "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", desc = "Preview hunk inline" },
        { "<leader>gP", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
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
