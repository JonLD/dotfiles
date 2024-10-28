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
                { "<leader>t", desc = "Grep Motion" },
                { "<leader>T", desc = "Grep Motion (cwd)" },
                { "<leader>sr", group = "Search and Replace Motion" },
            },
        },
    },
}
