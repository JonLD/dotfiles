local actions = require("telescope.actions")
-- local lga_actions = require("telescope-live-grep-args").actions
local custom_actions = function()
    require("plugins.telescope_actions")
end
local lga = function()
    require("telescope-live-grep-args.actions")
end
local telescope = require("telescope")
local path_tail = (function()
    local os_sep = require("telescope.utils").get_separator()

    return function(path)
        for i = #path, 1, -1 do
            if (path:sub(i, i) == os_sep) or (path:sub(i, i) == "/") then
                return path:sub(i + 1, -1)
            end
        end
        return path
    end
end)()

local function get_filename_then_path(opts, path)
    local tail = path_tail(path)
    return string.format("%-55s (%s)", tail, path)
end

return {
    {
        "tsakirist/telescope-lazy.nvim",
        keys = {
            {
                "<leader>fl",
                "<cmd>Telescope lazy<CR>",
            },
        },
    },
    {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
        config = function()
            require("telescope").load_extension("live_grep_args")
        end,
        opts = {
            mappings = {
                -- extend mappings
                i = {
                    ["<C-f>"] = function()
                        return require("telescope-live-grep-args.actions").quote_prompt
                    end,
                    -- ["<C-g>"] = function()
                    --     custom_actions.postfix_prompt({ postfix = " -g " })
                    -- end,
                    -- ["<C-w>"] = custom_actions.postfix_prompt({ postfix = " -w" }),
                    -- ["<C-r>"] = custom_actions.postfix_prompt({ postfix = " -F" }),
                    -- ["<C-d>"] = custom_actions.postfix_prompt({ postfix = " -g !'test*' -g !'Test*' " }),
                    -- ["<C-s>"] = custom_actions.postfix_prompt({ postfix = " -g !'*gmock*' " }),
                    -- ["<C-e>"] = custom_actions.postfix_prompt({ postfix = " -g !'*SOUP*' " }),
                },
            },
        },
        keys = {
            -- add a keymap to browse plugin files
            -- stylua: ignore
            {
                "<leader>sg",
                function()
                    require("telescope").extensions.live_grep_args.live_grep_args({})
                end,
                desc = "Live Grep",
            },
            {
                "<leader>sG",
                function()
                    require("telescope").extensions.live_grep_args.live_grep_args({ root = false })
                end,
                desc = "Grep (cwd)",
            },
        },
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        config = function()
            require("telescope").load_extension("file_browser")
        end,
        keys = {
            {
                "<leader>e",
                function()
                    require("telescope").extensions.file_browser.file_browser({ root = LazyVim.root() })
                end,
                desc = "File Browser",
                remap = true,
            },
            {
                "<leader>E",
                function()
                    require("telescope").extensions.file_browser.file_browser({ root = vim.uv.cwd() })
                end,
                desc = "File Browser",
                remap = true,
            },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        -- change some options
        opts = {
            defaults = {
                file_ignore_patterns = {},
                path_display = { "tail" },
                winblend = 0,
                dynamic_preview_title = true,
                cache_picker = {
                    num_pickers = 20,
                },
                mappings = {
                    i = {
                        ["<C-p>"] = actions.cycle_history_next,
                        ["<C-n>"] = actions.cycle_history_prev,
                        ["<C-l>"] = actions.select_default,
                        ["<C-b>"] = actions.preview_scrolling_up,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    },
                    n = {
                        ["<C-n>"] = actions.move_selection_next,
                        ["<C-p>"] = actions.move_selection_previous,
                        ["<c-l>"] = actions.select_default,
                    },
                },
                layout_strategy = "horizontal",
                sorting_strategy = "ascending",
                borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
                layout_config = {
                    prompt_position = "top",
                    width = 0.95,
                    height = 0.9,
                    preview_cutoff = 120,
                    horizontal = {
                        preview_width = function(_, cols, _)
                            if cols < 180 then
                                return math.floor(cols * 0.6)
                            end
                            return 130
                        end,
                        mirror = false,
                    },
                },
            },
            pickers = {

                git_branches = {},
                find_files = {
                    path_display = get_filename_then_path,
                },
            },
            extensions = {
                live_grep_args = {

                    defaults = {
                        previewer = true,
                        path_display = { "tail" },
                        -- -- define mappings, e.g.
                    },
                    -- auto_quoting = true, -- enable/disable auto-quoting
                    -- -- define mappings, e.g.
                    -- mappings = { -- extend mappings
                    --   i = {
                    --     ["<C-k>"] = lga_actions.quote_prompt(),
                    --     ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                    --     -- freeze the current list and start a fuzzy search in the frozen list
                    --     ["<C-space>"] = actions.to_fuzzy_refine,
                    --   },
                    -- },
                    -- ... also accepts theme settings, for example:
                    -- theme = "dropdown", -- use dropdown theme
                    -- theme = { }, -- use own theme spec
                    -- layout_config = { mirror=true }, -- mirror preview pane

                    -- auto_quoting = false, -- enable/disable auto-quoting
                },
                file_browser = {
                    select_buffer = true,
                    path = "%:p:h",
                    path_display = { "tail" },
                    previewer = true,
                    git_status = false,
                    hidden = true,
                    preview = {
                        hide_on_startup = true, -- hide previewer when picker starts
                    },
                },
            },
        },
    },
}
