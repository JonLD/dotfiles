return {
    { "LunarVim/darkplus.nvim" },
    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "darkplus",
        },
        priority = 1000,
    },
    {
        "folke/tokyonight.nvim",
        enabled = true,
    },
}
