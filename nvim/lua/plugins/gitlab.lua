return {
    {
        'https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim.git',
        enabled = false,
        build = 'npm install',
        event = { 'BufReadPre', 'BufNewFile' },
        ft = { 'c', 'cpp', 'go', 'python', 'rust', 'lua', 'typescript' },
        cond = function()
            return vim.env.GITLAB_TOKEN ~= nil and vim.env.GITLAB_TOKEN ~= ''
        end,
        opts = {
            {
                statusline = {
                    enabled = true
                },
                code_suggestions = {
                    enabled = true,
                    auto_filetypes = { 'c', 'cpp', 'go', 'python', 'rust', 'lua', 'typescript' },
                    ghost_text = {
                        enabled = true,
                        toggle_enabled = "<C-h>",
                        accept_suggestion = "<C-l>",
                        clear_suggestions = "<C-f>",
                        stream = true,
                    },
                }
            }
        },
    },
    {
        "JonLD/gitlab.nvim",
        dev = true,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "dlyongemallo/diffview.nvim",
            "stevearc/dressing.nvim",
        },
        build = "go build -o bin/server .",
        lazy = true,
        keys = {
            {
                "<leader>Mo",
                function()
                    local lib = require("diffview.lib")
                    if lib.get_current_view() then
                        require("gitlab").close_review()
                    else
                        require("gitlab").review()
                    end
                end,
                desc = "Toggle MR Review",
            },
            { "<leader>Ms", "<cmd>lua require('gitlab').summary()<CR>", desc = "MR Summary" },
            { "<leader>Mc", "<cmd>lua require('gitlab').create_comment()<CR>", desc = "Create Comment" },
            { "<leader>Mn", "<cmd>lua require('gitlab').move_to_discussion_tree_from_diagnostic()<CR>", desc = "Jump to Discussion" },
            { "<leader>Ml", "<cmd>lua require('gitlab').list_discussions()<CR>", desc = "List Discussions" },
            { "<leader>Mp", "<cmd>lua require('gitlab').pipeline()<CR>", desc = "MR Pipeline" },
            { "<leader>Mu", "<cmd>lua require('gitlab').copy_mr_url()<CR>", desc = "Copy MR URL" },
        },
        opts = {},
    },
}
