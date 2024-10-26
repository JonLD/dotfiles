return {
    -- add pyright to lspconfig
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = false,
            },

            -- pyright will be automatically installed with mason and loaded with lspconfig
            -- pyright = {},
            -- },
        },
    },
    { "nushell/tree-sitter-nu", event = "FileType", filetyoe = "nu", build = ":TSUpdate nu" },
}
