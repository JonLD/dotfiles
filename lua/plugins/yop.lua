return {
    {
        "zdcthomas/yop.nvim",
        config = function()
            require("yop").op_map({ "n", "v" }, "<space>t", function(lines)
                if #lines > 1 then -- Multiple lines can't be searched for
                    return
                end
                require("telescope").extensions.live_grep_args.live_grep_args({
                    search_dirs = { LazyVim.root() },
                    default_text = lines[1],
                })
            end)
            require("yop").op_map({ "v" }, "<space>/", function(lines)
                if #lines > 1 then -- Multiple lines can't be searched for
                    return
                end
                require("telescope").extensions.live_grep_args.live_grep_args({
                    search_dirs = { LazyVim.root() },
                    default_text = lines[1],
                })
            end)
            require("yop").op_map({ "v" }, "<space>sg", function(lines)
                if #lines > 1 then -- Multiple lines can't be searched for
                    return
                end
                require("telescope").extensions.live_grep_args.live_grep_args({
                    search_dirs = {},
                    default_text = lines[1],
                })
            end)
            require("yop").op_map({ "n", "v" }, "<space>T", function(lines)
                if #lines > 1 then -- Multiple lines can't be searched for
                    return
                end
                require("telescope").extensions.live_grep_args.live_grep_args({ default_text = lines[1] })
            end)
            require("yop").op_map({ "n", "v" }, "<space>sr", function(lines)
                if #lines > 1 then -- Multiple lines can't be searched for
                    return
                end
                require("grug-far").open({ startInInsertMode = false, prefills = { search = lines[1] } })
            end)
        end,
    },
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<leader>t", desc = "Grep Motion", icon = { icon = " ", color = "green" } },
                { "<leader>T", desc = "Grep Motion (cwd)", icon = { icon = " ", color = "green" } },
                { "<leader>sr", desc = "Search and Replace Motion", icon = { icon = "󰛔 ", color = "yellow" } },
            },
        },
    },
}
