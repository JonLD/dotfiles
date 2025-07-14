if false then
    return {}
end

return {
    {
        "2kabhishek/nerdy.nvim",
        dependencies = {
            'folke/snacks.nvim',
        },
        cmd = "Nerdy",
    },
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<leader>pu", desc = "Upload",
                    icon = { icon = " ", color = "cyan" }
                },
                {
                    "<leader>pb",
                    desc = "Build",
                    icon = { icon = "󰇺 ", color = "cyan" }
                },
                {
                    "<leader>pl",
                    desc = "generate compile commands",
                    icon = { icon = " ", color = "orange" }
                },
                {
                    "<leader>pi",
                    desc = "Initialise Project",
                    icon = { icon = " ", color = "green" }
                },
                {
                    "<leader>pc",
                    desc = "Clean",
                    icon = { icon = " ", color = "red" }
                },
                {
                    "<leader>pt",
                    desc = "Terminal",
                    icon = { icon = " ", color = "red" }
                },
                {
                    "<leader>pm",
                    desc = "Monitor",
                },
                {
                    "<leader>pl",
                    desc = "Lib search",
                   icon = { icon = " ", color = "green" }

                },
                {
                    "<leader>pd",
                    desc = "Debug",
                   icon = { icon = " ", color = "red" }
                },
                {
                    "<leader>pe",
                    desc = "Select Env",
                   icon = { icon = " ", color = "blue" }
                },
                { "<leader>p", group = "PlatformIO", icon = { icon = " ", color = "orange" } },
            },
        },
    },
    {
        "JonLD/platformio.nvim",
        enabled = false,
        dev = true,
        lazy = true,
        cmd = {
            "Pio",
            "Piorun",
            "Piodb",
            "Pioinit",
            "Piocmd",
            "Piomon",
            "Piolib",
            "Piodebug",
            "Pioenv",
        },
        keys = {
            {
                "<leader>pu",
                "<cmd>Piorun upload<CR>",
                desc = "Upload",
            },
            {
                "<leader>pb",
                "<cmd>Piorun build<CR>",
                desc = "Build",
            },
            {
                "<leader>pl",
                "<cmd>Piodb<CR>",
                desc = "generate compile commands",
            },
            {
                "<leader>pi",
                "<cmd>Pioinit<CR>",
                desc = "Initialise Project",
            },
            {
                "<leader>pc",
                "<cmd>Piorun clean<CR>",
                desc = "Clean",
            },
            {
                "<leader>pt",
                "<cmd>Piocmd<CR>",
                desc = "Terminal",
            },
            {
                "<leader>pm",
                "<cmd>Piomon<CR>",
                desc = "Monitor",
            },
            {
                "<leader>pl",
                "<cmd>Piolib<CR>",
                desc = "Lib search",
            },
            {
                "<leader>pd",
                "<cmd>Piodebug<CR>",
                desc = "Debug",
            },
            {
                "<leader>pe",
                "<cmd>Pioenv<CR>",
                desc = "Select Env",
            },
        },
    },
    -- {
    --     "nvim-lualine/lualine.nvim",
    --     opts = function(_, opts)
    --         local icon = LazyVim.config.icons.kinds.TabNine
    --         table.insert(opts.sections.lualine_x, 2, LazyVim.lualine.cmp_source("cmp_tabnine", icon))
    --     end,
    -- },
    {
        "JonLD/darkmodern.nvim",
        dev = true,
        enabled = false,
    },
}
