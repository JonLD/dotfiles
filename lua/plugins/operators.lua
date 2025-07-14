return {
    "echasnovski/mini.operators",
    opts = {
        replace = {
            prefix = "gp"
        },
    },
    keys = function(_, keys)
        local opts = LazyVim.opts("mini.operators")
        local mappings = {
            { opts.replace.prefix, desc = "Put replace motion", mode = { "n", "x" } },
        }
        mappings = vim.tbl_filter(function(m)
            return m[1] and #m[1] > 0
        end, mappings)
        return vim.list_extend(mappings, keys)
    end,
}
