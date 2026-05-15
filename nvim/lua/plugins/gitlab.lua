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
        "dlyongemallo/diffview.nvim",
        opts = {
            enhanced_diff_hl = true,
            view = {
                default = { layout = "diff2_horizontal" },
            },
        },
        config = function(_, opts)
            require("diffview").setup(opts)
            -- Filler lines on the opposite side of an add/delete: blend into background
            vim.api.nvim_set_hl(0, "DiffviewDiffDeleteDim", { link = "Normal" })
            vim.api.nvim_set_hl(0, "DiffviewDiffAddDim", { link = "Normal" })
            vim.opt.fillchars:append({ diff = " " })
        end,
    },
    {
        "JonLD/gitlab.nvim",
        dev = true,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "dlyongemallo/diffview.nvim",
        },
        build = "go build -o bin/server .",
        lazy = true,
        keys = {
            {
                "<leader>mo",
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
            { "<leader>ms", "<cmd>lua require('gitlab').summary()<CR>", desc = "MR Summary" },
            { "<leader>mc", "<cmd>lua require('gitlab').create_comment()<CR>", desc = "Create Comment" },
            { "<leader>mn", "<cmd>lua require('gitlab').move_to_discussion_tree_from_diagnostic()<CR>", desc = "Jump to Discussion" },
            { "<leader>ml", "<cmd>lua require('gitlab').list_discussions()<CR>", desc = "List Discussions" },
            { "<leader>mp", "<cmd>lua require('gitlab').pipeline()<CR>", desc = "MR Pipeline" },
            { "<leader>mu", "<cmd>lua require('gitlab').copy_mr_url()<CR>", desc = "Copy MR URL" },
            { "<leader>mm", "<cmd>lua require('gitlab').choose_merge_request()<CR>", desc = "Choose MR" },
            { "]g", function() require("gitlab").next_discussion() end, desc = "Next MR comment" },
            { "[g", function() require("gitlab").prev_discussion() end, desc = "Prev MR comment" },
        },
        opts = {
            discussion_tree = {
                auto_open = false,
            },
            discussion_signs = {
                icons = {
                    comment = "💬",
                    range = "│",
                    resolved = " ",
                    resolved_range = "│",
                },
            },
        },
    },
}
