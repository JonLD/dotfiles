local util = require("util")

---@param scale_factor number
---@return number
local function clamp_scale_factor(scale_factor)
    return math.max(math.min(scale_factor, vim.g.neovide_max_scale_factor), vim.g.neovide_min_scale_factor)
end

---@param scale_factor number
---@param clamp? boolean
local function set_scale_factor(scale_factor, clamp)
    vim.g.neovide_scale_factor = clamp and clamp_scale_factor(scale_factor) or scale_factor
end

local function reset_scale_factor()
    vim.g.neovide_scale_factor = vim.g.neovide_initial_scale_factor
end

---@param increment number
---@param clamp? boolean
local function change_scale_factor(increment, clamp)
    set_scale_factor(vim.g.neovide_scale_factor + increment, clamp)
end

-- local function toggle_fullscreen()
--     if vim.g.neovide_fullscreen then
--         vim.g.neovide_fullscreen = false
--     else
--         vim.g.neovide_fullscreen = true
--     end
-- end


local toggle_fullscreen = LazyVim.toggle.wrap({
    name = "Fullscreen",
    get = function()
        return vim.g.neovide_fullscreen
    end,
    set = function(state)
        vim.g.neovide_fullscreen = state
    end,
})


if vim.g.neovide then
    util.map("<F11>", toggle_fullscreen)
    util.map("<leader>um", toggle_fullscreen)
end

---@type LazySpec
return {
    "AstroNvim/astrocore",
    cond = vim.g.neovide,
    ---@type AstroCoreOpts
    opts = {
        options = {
            opt = {
                guifont = "JetBrainsMonoNL NF",
                linespace = 0,
            },
            g = {
                neovide_cursor_animation_length = 0.08,
                neovide_cursor_trail_size = 0,
                neovide_cursor_antialiasing = true,
                neovide_cursor_animate_command_line = false,
                neovide_cursor_smooth_blink = true,
                neovide_increment_scale_factor = vim.g.neovide_increment_scale_factor or 0.1,
                neovide_min_scale_factor = vim.g.neovide_min_scale_factor or 0.7,
                neovide_max_scale_factor = vim.g.neovide_max_scale_factor or 2.0,
                neovide_initial_scale_factor = vim.g.neovide_scale_factor or 1,
                neovide_scale_factor = vim.g.neovide_scale_factor or 1,
            },
        },
        commands = {
            NeovideSetScaleFactor = {
                function(event)
                    local scale_factor, option = tonumber(event.fargs[1]), event.fargs[2]

                    if not scale_factor then
                        vim.notify(
                            "Error: scale factor argument is nil or not a valid number.",
                            vim.log.levels.ERROR,
                            { title = "Recipe: neovide" }
                        )
                        return
                    end

                    set_scale_factor(scale_factor, option ~= "force")
                end,
                nargs = "+",
                desc = "Set Neovide scale factor",
            },
            NeovideResetScaleFactor = {
                reset_scale_factor,
                desc = "Reset Neovide scale factor",
            },
        },
        mappings = {
            n = {
                ["<C-=>"] = {
                    function()
                        change_scale_factor(vim.g.neovide_increment_scale_factor * vim.v.count1, true)
                    end,
                    desc = "Increase Neovide scale factor",
                },
                ["<C-->"] = {
                    function()
                        change_scale_factor(-vim.g.neovide_increment_scale_factor * vim.v.count1, true)
                    end,
                    desc = "Decrease Neovide scale factor",
                },
                ["<C-0>"] = { reset_scale_factor, desc = "Reset Neovide scale factor" },
            },
        },
    },
}
