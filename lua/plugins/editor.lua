return {
    {
        "MagicDuck/grug-far.nvim",
        keys = {
            { "<leader>sr", false },
            {
                "<leader>R",
                function()
                    local grug = require("grug-far")
                    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                    grug.open({
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                        },
                    })
                end,
                mode = { "n", "v" },
                desc = "Search and Replace",
            },
        },
    },
    {
        "tiagovla/scope.nvim",
        config = function()
            require("scope").setup({})
        end,
    },
    {
        "psliwka/vim-smoothie",
        cond = function()
            if vim.g.neovide then
                return false
            else
                return true
            end
        end,
        keys = {
            {
                "<C-j>",
                '<cmd>call smoothie#do("\\<C-D>") <CR>',
            },
            {
                "<C-k>",
                '<cmd>call smoothie#do("\\<C-U>") <CR>',
            },
        },
    },
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = "LazyFile",
        opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>sxt", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sxT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
      { "<leader>st", false },
      { "<leader>sT", false },
    },
    },
    {
        "karb94/neoscroll.nvim",
        cond = false,
        opts = {
            mappings = { "zz", "zt", "zb" },
            -- easing = "quadratic",
        },
        keys = {
            {
                "<C-k>",
                function()
                    require("neoscroll").ctrl_u({ duration = 200 })
                end,
            },
            {
                "<C-j>",
                function()
                    require("neoscroll").ctrl_d({ duration = 200 })
                end,
            },
            -- {
            --     "<C-b>",
            --     function()
            --         require("neoscroll").ctrl_b({ duration = 450 })
            --     end,
            -- },
            -- {
            --     "<C-f>",
            --     function()
            --         require("neoscroll").ctrl_f({ duration = 450 })
            --     end,
            -- },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        -- Not all LSP servers add brackets when completing a function.
        -- To better deal with this, LazyVim adds a custom option to cmp,
        -- that you can configure. For example:
        --
        -- ```lua
        -- opts = {
        --   auto_brackets = { "python" }
        -- }
        -- ```
        opts = function()
            vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
            local cmp = require("cmp")
            local defaults = require("cmp.config.default")()
            local auto_select = true
            return {
                auto_brackets = {}, -- configure any filetype to auto add brackets
                completion = {
                    completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
                },
                preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.insert({
                    ["<C-y>"] = cmp.config.disable,
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
                    ["<C-l>"] = LazyVim.cmp.confirm({ select = true }),
                    ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<C-CR>"] = function(fallback)
                        cmp.abort()
                        fallback()
                    end,
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
                formatting = {
                    format = function(entry, item)
                        local icons = LazyVim.config.icons.kinds
                        if icons[item.kind] then
                            item.kind = icons[item.kind] .. item.kind
                        end

                        local widths = {
                            abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
                            menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
                        }

                        for key, width in pairs(widths) do
                            if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
                            end
                        end

                        return item
                    end,
                },
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
                sorting = defaults.sorting,
            }
        end,
        main = "lazyvim.util.cmp",
    },
}
