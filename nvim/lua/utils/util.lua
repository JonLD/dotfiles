M = {}

function M.not_firenvim()
    if vim.g.started_by_firenvim then
        return false
    else
        return true
    end
end

return M
