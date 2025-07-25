-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Hide terminal buffers from bufferline
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.buflisted = false
  end,
  desc = "Hide terminal buffers from bufferline"
})
