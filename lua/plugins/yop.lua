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
            require("yop").op_map({ "n", "v" }, "gp", function(lines, info)
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

            require("yop").op_map({ "n", "v" }, "gP", function(lines, info)
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
            },
        },
    },
}
