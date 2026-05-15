return {
    { "supermaven-inc/supermaven-nvim", cond = false },
    {
        "JonLD/codex.nvim",
        lazy = true,
        cmd = { "Codex", "CodexSendSelected", "CodexSendFile" },
        keys = {
            { "<leader>a", nil, desc = "AI" },
            -- { "<C-\\>", "<CMD>Codex<CR>", mode = { "n", "x" }, desc = "Toggle Codex" },
            { "<leader>aC", "<CMD>Codex resume --last<CR>", desc = "Codex resume last chat" },
            -- { "<leader>ar", "<CMD>Codex resume<CR>", desc = "Codex resume last chat" },
            -- { "<leader>as", "<CMD>CodexReferenceSelected!<CR>", mode = { "n", "v" }, desc = "Send to Codex" },
            -- { "<leader>at", "<CMD>CodexSendSelected!<CR>", mode = { "n", "v" }, desc = "Send to Codex" },
            -- { "<leader>af", "<CMD>CodexReferenceFile!<CR>", mode = { "n", "v" }, desc = "Send to Codex" },
        },
        opts = {
            log_level = "debug",
            shell = {
                cmd = "nu",
                args = { "-c" },
                env = {
                    -- Preserve Windows Terminal environment
                    WT_SESSION = vim.env.WT_SESSION,
                    WT_PROFILE_ID = vim.env.WT_PROFILE_ID,
                },
            },
        },
    },
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        opts = {
            -- Preserve Windows Terminal environment variables
            env = {
                WT_SESSION = vim.env.WT_SESSION or "",
                WT_PROFILE_ID = vim.env.WT_PROFILE_ID or "",
            },
            diff_opts = {
                open_in_new_tab = true,
            },
            terminal = {
                -- snacks provider has auto_insert=true so it re-enters terminal mode
                -- when switching back to the Claude buffer (native provider does not)
                provider = "snacks",
                snacks_win_opts = {
                    keys = {
                        -- Override snacks' expr-based Esc: use chansend to write the raw
                        -- byte directly to the terminal process, bypassing ConPTY translation.
                        -- First Esc goes to Claude Code; double Esc within 200ms exits terminal mode.
                        term_normal = {
                            "<Esc>",
                            function(self)
                                self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
                                local chan = vim.bo[self.buf].channel
                                if self.esc_timer:is_active() then
                                    self.esc_timer:stop()
                                    vim.cmd("stopinsert")
                                elseif chan > 0 then
                                    self.esc_timer:start(200, 0, function() end)
                                    vim.fn.chansend(chan, "\27")
                                end
                            end,
                            mode = "t",
                            desc = "Pass Esc to Claude (double Esc exits terminal mode)",
                        },
                        -- Windows ConPTY doesn't forward <S-Tab> as the ANSI CSI Z sequence
                        -- (\e[Z) that Claude Code's TUI expects. Send it directly.
                        shift_tab = {
                            "<S-Tab>",
                            function(self)
                                local chan = vim.bo[self.buf].channel
                                if chan > 0 then
                                    vim.fn.chansend(chan, "\27[Z")
                                end
                            end,
                            mode = "t",
                            desc = "Pass Shift+Tab to Claude",
                        },
                        alt_p = {
                            "<A-p>",
                            function(self)
                                local chan = vim.bo[self.buf].channel
                                if chan > 0 then
                                    vim.fn.chansend(chan, "\27p")
                                end
                            end,
                            mode = "t",
                            desc = "Pass Alt+P to Claude",
                        },
                    },
                },
            },
            focus_after_send = true,
        },
        keys = {
            { "<leader>a", nil, desc = "AI" },
            { "<C-\\>", "<CMD>ClaudeCode<CR>", desc = "Toggle Claude" },
            { "<leader>aR", "<CMD>ClaudeCode --resume<CR>", desc = "Resume Claude" },
            { "<leader>ac", "<CMD>ClaudeCode --continue<CR>", desc = "Continue Claude" },
            { "<leader>am", "<CMD>ClaudeCodeSelectModel<CR>", desc = "Select Claude model" },
            { "<leader>ab", "<CMD>ClaudeCodeAdd %<CR>", desc = "Add current buffer" },
            { "<leader>as", "<CMD>ClaudeCodeSend<CR>", mode = "v", desc = "Send to Claude" },
            {
                "<leader>at",
                "<CMD>ClaudeCodeTreeAdd<CR>",
                desc = "Add file",
                ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
            },
            -- Diff management
            { "<leader>aa", "<CMD>ClaudeCodeDiffAccept<CR>", desc = "Accept diff" },
            { "<leader>ad", "<CMD>ClaudeCodeDiffDeny<CR>", desc = "Deny diff" },
        },
    },
}
