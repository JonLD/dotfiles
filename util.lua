M = {}
function M.map(lhs, toggle)
  local t = LazyVim.toggle.wrap(toggle)
  vim.keymap.set("n", lhs, function()
    t()
  end, { desc = "Toggle " .. toggle.name })
  LazyVim.toggle.wk(lhs, toggle)
end

return M
