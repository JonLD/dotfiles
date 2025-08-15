return {
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        opts = {
            shell = {
                cmd = "nu",
                args = { "-c" },
                env = {
                    -- Preserve Windows Terminal environment
                    WT_SESSION = vim.env.WT_SESSION,
                    WT_PROFILE_ID = vim.env.WT_PROFILE_ID,
                },
            },
            -- Add Windows-specific path handling
            path_separator = "\\",
            -- Ensure proper diff handling on Windows
            diff = {
                tool = "git", -- Use git diff which works well on Windows
            },
            -- Set window width to 40% of screen
            window = {
                width = 0.4,  -- 40% of the editor width
                position = "right",  -- Open on the right side
            },
        },
        keys = {
            { "<leader>a", nil, desc = "AI/Claude Code" },
            { "<C-z>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
            { "<leader>ac", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
            {
                "<leader>as",
                "<cmd>ClaudeCodeTreeAdd<cr>",
                desc = "Add file",
                ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
            },
            -- Diff management
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
        },
    },
    {
        "ravitemer/mcphub.nvim",
        cond = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>am", "<CMD>MCPHub<CR>", desc = "Open MCPHub" },
            { "<leader>as", "<CMD>MCPHubSearch<CR>", desc = "Search MCPHub" },
            { "<leader>aC", "<CMD>MCPHubChat<CR>", desc = "Chat with MCPHub" },
            { "<leader>at", "<CMD>MCPHubTools<CR>", desc = "MCPHub Tools" },
        },
        build = "npm install -g mcp-hub@latest",
        config = function()
            require("mcphub").setup({
                port = 3000,
                config = vim.fn.expand("~/mcpservers.json"),
            })
            -- Load enhanced Neovim integration server
            require("mcp.neovim_enhanced")

            -- Add custom instructions for neovim_enhanced server
            vim.defer_fn(function()
                local mcphub = require("mcphub")
                local hub = mcphub.get_hub_instance()
                if hub then
                    hub:update_server_config("neovim_enhanced", {
                        custom_instructions = {
                            disabled = false,
                            text = [[
**When user mentions code/functions, ALWAYS:**

1. **`list_buffers`** - See what files are open in Neovim
2. **`find_symbols`** - Search for the symbol across workspace/buffers to find its location
3. **Request file access** - "I found the symbol in `file.js`. Can I read that file to help you?"
4. **Use symbol navigation** - After access, use `goto_definition`, `find_references`, etc.

**ALWAYS PREFER LSP tools for code navigation:**
- `find_symbols` - Programmatic symbol search (BEST for finding functions/classes/variables)
- `snacks_symbol_search` - Interactive picker for user exploration and fuzzy finding
- `goto_definition` - Navigate to definitions
- `find_references` - Find usage locations

**AVOID text search tools for code navigation** - LSP tools understand code semantically and are far superior.

**Key principle**: Use Neovim tools to DISCOVER files and symbols, then request access - don't wait for manual file attachments!
                            ]]
                        }
                    })
                end
            end, 1000)
        end,
    },
}
