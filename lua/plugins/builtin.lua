local util = require("util")

return {
    {
        "nvim-lualine/lualine.nvim",
        cond = util.not_firenvim(),
        -- opts = function(_, opts)
        --     local icon = LazyVim.config.icons.kinds.TabNine
        --     table.insert(opts.sections.lualine_x, 2, LazyVim.lualine.cmp_source("cmp_tabnine", icon))
        -- end,
    },
    {
        "lewis6991/gitsigns.nvim",
        cond = util.not_firenvim(),
    },
    {
        "ahmedkhalf/project.nvim",
        cond = util.not_firenvim(),
        opts = {
            scope_chdir = "tab",
        },
    },
    {
        "ThePrimeagen/refactoring.nvim",
        cond = util.not_firenvim(),
    },
    {
        "folke/flash.nvim",
        lazy = true,
    },
    { "rcarriga/nvim-notify", enabled = false },
    { "folke/noice.nvim", cond = util.not_firenvim(), enabled = true },
}
