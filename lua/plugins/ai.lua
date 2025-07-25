return {
    {
        "greggh/claude-code.nvim",
        dev = true,  -- Use local development version
        dependencies = {
            "nvim-lua/plenary.nvim", -- Required for git operations
        },
        keys = {
            { "<C-z>", "<CMD>ClaudeCode<CR>", desc = "Toggle Claude terminal" },
            { "<leader>ac", "<CMD>ClaudeCodeContinue<CR>", desc = "Claude continue" },
            { "<leader>a", group = "AI", icon = "🤖" },
            { "<leader>ar", "<CMD>ClaudeCodeConversations<CR>", desc = "Claude conversations (local)" },
            { "<leader>aR", "<CMD>ClaudeCodeConversationsGlobal<CR>", desc = "Claude conversations (global)" },
            { "<leader>ae", "<CMD>ClaudeCodeEditSummary<CR>", desc = "Edit current conversation summary" },
        },
        opts = {
            shell = {
                separator = ';',      -- Use ';' instead of '&&' for nushell
                pushd_cmd = 'cd',     -- Use 'cd' for directory changes in nushell
                popd_cmd = '',        -- Empty since we're not using directory stack
            },
            git = {
                use_git_root = true,  -- Keep git root functionality with nushell-compatible commands
            },
            window = {
                position = "vertical"  -- Open in vertical split instead of horizontal
            },
            keymaps = {
                window_navigation = false,
                toggle = {
                    normal = false,  -- disable plugin's default keymap
                    terminal = false,
                },
            },
        },
    },
    {
        "jackMort/ChatGPT.nvim",
        event = "VeryLazy",
        config = function()
            require("chatgpt").setup()
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim", -- optional
            "nvim-telescope/telescope.nvim"
        },
        keys = {
            { "<leader>af", "<CMD>ChatGPT<CR>", desc = "OpenChatCGPT"},
            { "<leader>ae", "<CMD>ChatGPTEditWithInstructions<CR>", desc = "OpenChatGPT"},
        }
    },
}
