return {
    {
        "JonLD/claude-code.nvim",
        enabled = true,
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
            command = "claude --append-system-prompt '(uvx --from git+https://github.com/oraios/serena serena print-system-prompt)'",
            shell = {
                separator = ";", -- Use ';' instead of '&&' for nushell
                pushd_cmd = "cd", -- Use 'cd' for directory changes in nushell
                popd_cmd = "", -- Empty since we're not using directory stack
            },
            git = {
                use_git_root = true, -- Keep git root functionality with nushell-compatible commands
            },
            window = {
                position = "vertical", -- Open in vertical split instead of horizontal
                split_ratio = 0.5, -- Set to half the editor width (50% for vertical splits)
            },
            keymaps = {
                window_navigation = false,
                toggle = {
                    normal = false, -- disable plugin's default keymap
                    terminal = false,
                },
            },
        },
    },
    {
        "zbirenbaum/copilot.lua",
        cond = false,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        enabled = false,
    },
    {
        "olimorris/codecompanion.nvim",
        cond = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "ravitemer/mcphub.nvim",
        },
        keys = {
            { "<leader>ae", "<CMD>CodeCompanion<CR>", desc = "Open Code Companion" },
            { "<leader>aa", "<CMD>CodeCompanionChat<CR>", desc = "Open Code Companion" },
            { "<leader>af", "<CMD>CodeCompanionCommand<CR>", desc = "Generate code with Code Companion" },
            { "<leader>af", "<CMD>CodeCompanionActions<CR>", desc = "Generate code with Code Companion" },
            { "<leader>as", "<CMD>CodeCompanionSearch<CR>", desc = "Search code with Code Companion" },
        },
        config = function()
            require("codecompanion").setup({
                strategies = {
                    chat = {
                        adapter = "anthropic",
                        tools = {
                            opts = {
                                show_in_chat = true, -- Show tools in chat
                                show_in_command = true, -- Show tools in command
                                default_tools = {
                                    "neovim",
                                    "context7",
                                    "filesystem",
                                    "memory",
                                    "sequentialthinking",
                                    "neovim_enhanced",
                                }
                            },
                        }
                    },
                    inline = {
                        adapter = "anthropic",
                    },
                    cmd = {
                        adapter = "anthropic",
                    },
                },
                adapters = {
                    anthropic = function()
                        return require("codecompanion.adapters").extend("anthropic", {
                            schema = {
                                max_tokens = {
                                    default = 64000, -- Change this value (1-128000)
                                },
                            },
                        })
                    end,
                },
                display = {
                    chat = {
                        show_tools_processing = true, -- Show loading message when tools are being executed
                        show_token_count = true, -- Show token count for each response
                        auto_scroll = true, -- Automatically scroll down
                        start_in_insert_mode = false, -- Don't start in insert mode
                        icons = {
                            loading = " ", -- Loading spinner icon
                        },
                    },
                },

            })

            -- Initialize MCPHub extension after CodeCompanion is set up
            local mcphub_ext = require("mcphub.extensions.codecompanion")
            mcphub_ext.setup({
                enabled = true,
                make_vars = true,
                make_slash_commands = true,
                make_tools = true,
                show_server_tools_in_chat = true,
                add_mcp_prefix_to_tool_names = false,
                show_result_in_chat = true,
                format_tool = function(tool_result)
                    return tool_result
                end,
            })
        end,
    },
    {
        "ravitemer/mcphub.nvim",
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
