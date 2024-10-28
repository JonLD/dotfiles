if not require("util").not_firenvim() then
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
    "glacambre/firenvim",
    cond = not require("util").not_firenvim(),
    build = ":call firenvim#install(0)",
}
