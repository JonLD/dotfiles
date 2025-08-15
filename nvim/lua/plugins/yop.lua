return {
    {
        "zdcthomas/yop.nvim",
        config = function()
            require("yop").op_map({ "n", "v" }, "<space>t", function(lines)
                if #lines > 1 then -- Multiple lines can't be searched for
                    return
                end
                Snacks.picker.grep_word({
                    search = lines[1]
                })
            end)
            require("yop").op_map({ "n", "v" }, "<space>T", function(lines)
                if #lines > 1 then -- Multiple lines can't be searched for
                    return
                end
                Snacks.picker.grep({
                    search = lines[1]
                })
            end)
            require("yop").op_map({ "n", "v" }, "<space>sr", function(lines)
                if #lines > 1 then -- Multiple lines can't be searched for
                    return
                end
                require("grug-far").open({ startInInsertMode = false, prefills = { search = lines[1] } })
            end)

            -- Yanky replace operators
            require("yop").op_map({ "n", "v" }, "gP", function(lines, info)
                -- Get current register content to put
                local register_content = vim.fn.getreg('"')
                local register_type = vim.fn.getregtype('"')

                if register_content == "" then
                    return lines -- No content to put, return original
                end

                -- Save the deleted text to register (like visual mode p)
                vim.schedule(function()
                    local deleted_text = table.concat(lines, "\n")
                    vim.fn.setreg('"', deleted_text, info.regtype or 'v')

                    -- Initialize yanky ring for cycling
                    require("yanky").put("p", false, function() end)
                end)

                -- Return yanky register content to replace the motion text
                if register_type == "V" then
                    return vim.split(register_content, "\n")
                else
                    return vim.split(register_content, "\n")
                end
            end)

            require("yop").op_map({ "n", "v" }, "gp", function(lines, info)
                -- Get current register content to put
                local register_content = vim.fn.getreg('"')
                local register_type = vim.fn.getregtype('"')

                if register_content == "" then
                    return lines -- No content to put, return original
                end

                -- Don't save deleted text (like visual mode P)
                vim.schedule(function()
                    -- Initialize yanky ring for cycling
                    require("yanky").put("P", false, function() end)
                end)

                -- Return yanky register content to replace the motion text
                if register_type == "V" then
                    return vim.split(register_content, "\n")
                else
                    return vim.split(register_content, "\n")
                end
            end)

            -- Line-wise yanky operators (gpp and gPP for current line)
            vim.keymap.set("n", "gpp", function()
                -- Get current register content
                local register_content = vim.fn.getreg('"')
                local register_type = vim.fn.getregtype('"')

                if register_content == "" then
                    return -- No content to put
                end

                -- Get current line
                local current_line = vim.api.nvim_get_current_line()

                -- Save current line to register (like visual mode p)
                vim.fn.setreg('"', current_line, 'V')

                -- Replace current line with register content
                if register_type == "V" then
                    -- Line-wise register - replace entire line
                    vim.api.nvim_set_current_line(vim.trim(register_content))
                else
                    -- Character-wise register - replace entire line
                    vim.api.nvim_set_current_line(register_content)
                end

                -- Initialize yanky ring for cycling
                require("yanky").put("p", false, function() end)
            end, { desc = "Replace current line with yanky (update register)" })

            vim.keymap.set("n", "gPP", function()
                -- Get current register content
                local register_content = vim.fn.getreg('"')
                local register_type = vim.fn.getregtype('"')

                if register_content == "" then
                    return -- No content to put
                end

                -- Replace current line with register content (don't save deleted line)
                if register_type == "V" then
                    -- Line-wise register - replace entire line
                    vim.api.nvim_set_current_line(vim.trim(register_content))
                else
                    -- Character-wise register - replace entire line
                    vim.api.nvim_set_current_line(register_content)
                end

                -- Initialize yanky ring for cycling
                require("yanky").put("P", false, function() end)
            end, { desc = "Replace current line with yanky (preserve register)" })
        end,
    },
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<leader>t", desc = "Grep Word Motion", icon = { icon = " ", color = "green" } },
                { "<leader>T", desc = "Grep Motion", icon = { icon = " ", color = "green" } },
                { "<leader>sr", desc = "Search and Replace Motion", icon = { icon = "󰛔 ", color = "yellow" } },
                { "gp", desc = "Yanky Replace Motion (update register)", icon = { icon = "󰆏 ", color = "blue" } },
                { "gP", desc = "Yanky Replace Motion (preserve register)", icon = { icon = "󰆐 ", color = "cyan" } },
                { "gpp", desc = "Yanky Replace Current Line (update register)", icon = { icon = "󰆓 ", color = "blue" } },
                { "gPP", desc = "Yanky Replace Current Line (preserve register)", icon = { icon = "󰆔 ", color = "cyan" } },
            },
        },
    },
}
