return {
    {"rydesun/tree-sitter-dot",},
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
}
