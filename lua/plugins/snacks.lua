
return {
    "folke/snacks.nvim",
    keys = {
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader>sb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>sf", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>N", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    },
    opts = {
        styles = {
            terminal = {
                position = "right"
            },
        },
        picker = {
            -- layout = "borderless_top",
            layouts = {
                borderless_top = {
                    layout = {
                        box = "horizontal",
                        backdrop = false,
                        width = 0.95,
                        heigh = 0.8,
                        border = "none",
                        {
                            box = "vertical",
                            { win = "input", height = 2, border = "none", title = "{title} {live} {flags}", title_pos = "center" },
                            { win = "list", title = " Results ", title_pos = "center", border = "none" },
                        },
                        {
                            win = "preview",
                            title = "{preview:Previw",
                            width = 0.6,
                            border = "none",
                            title_pos = "center",
                        }
                    }
                }
            },
            win = {
                input = {
                    keys = {
                        ["<C-l>"] = { "confirm", mode = { "n", "i" } },
                    },
                },
            }
        },
        dashboard = { enabled = require("utils.util").not_firenvim() }
    },
}
