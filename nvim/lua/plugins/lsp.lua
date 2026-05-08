return {
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            inlay_hints = { enabled = false },
            servers = {
                clangd = {
                    root_dir = function(bufnr)
                        local fname = type(bufnr) == "number" and vim.api.nvim_buf_get_name(bufnr) or bufnr
                        return require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname)
                            or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
                    end,
                },
            },
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = false,
            },

        },
    },
}
