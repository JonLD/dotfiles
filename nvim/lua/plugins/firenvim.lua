local util = require("utils.util")

if not util.not_firenvim() then
    vim.g.firenvim_config = {
        globalSettings = { alt = "all" },
        localSettings = {
            [".*"] = {
                cmdline = "neovim",
                content = "text",
                priority = 0,
                selector = "textarea",
                takeover = "never",
            },
        },
    }
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = "github.com_*.txt",
        command = "set filetype=markdown",
    })
end


return {
    {
        "glacambre/firenvim",
        cond = not util.not_firenvim(),
        build = ":call firenvim#install(0)",
    },
    {
        "nvim-lualine/lualine.nvim",
        cond = util.not_firenvim(),
    },
    {
        "lewis6991/gitsigns.nvim",
        cond = util.not_firenvim(),
    },
    { "folke/noice.nvim", cond = util.not_firenvim() },
}
