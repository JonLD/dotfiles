return {
    {
        'lervag/vimtex',
        lazy = false,  -- Don't lazy load VimTeX
        config = function()
            -- PDF viewer configuration
            vim.g.vimtex_view_method = 'general'
            vim.g.vimtex_view_general_viewer = 'SumatraPDF'
            vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'

            -- Compiler settings
            vim.g.vimtex_compiler_latexmk = {
                continuous = 1,  -- Auto-compile on save
                callback = 1,
            }

            -- Use pdflatex (most compatible with CV templates)
            vim.g.vimtex_compiler_latexmk_engines = {
                _ = '-pdf'
            }

            -- Cleaner quickfix for errors
            vim.g.vimtex_quickfix_ignore_filters = {
                'Underfull \\hbox',
                'Overfull \\hbox',
                'LaTeX Warning: .\\+ float specifier changed to',
            }
        end
    },
}
