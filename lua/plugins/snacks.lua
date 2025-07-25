

return {
    "folke/snacks.nvim",
    keys = {
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader>sb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>sf", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>N", function() Snacks.notifier.show_history() end, desc = "Notification History" },
        { "<leader>e", function()
            local function file_browser(start_dir)
                local current_dir = start_dir or vim.fn.expand('%:p:h')
                if current_dir == '' then
                    current_dir = vim.loop.cwd()
                end

                local function browse_directory(dir)
                    local uv = vim.loop
                    local entries = {}

                    -- Add parent directory entry if not at root
                    if dir ~= "/" and dir ~= "\\" and not dir:match("^%a:[\\/]?$") then
                        table.insert(entries, {
                            text = "../",
                            file = vim.fn.fnamemodify(dir, ":h"),
                            is_dir = true,
                        })
                    end

                    -- Read directory contents
                    local handle = uv.fs_scandir(dir)
                    if handle then
                        while true do
                            local name, type = uv.fs_scandir_next(handle)
                            if not name then break end

                            local full_path = dir .. (dir:match("[\\/]$") and "" or "/") .. name
                            -- Use same logic as snacks explorer
                            local is_dir = type == "directory" or (type == "link" and vim.fn.isdirectory(full_path) == 1)

                            table.insert(entries, {
                                text = name,
                                file = full_path,
                                dir = is_dir,
                            })
                        end
                    end

                    -- Sort: directories first, then files
                    table.sort(entries, function(a, b)
                        if a.dir and not b.dir then return true end
                        if not a.dir and b.dir then return false end
                        return a.text < b.text
                    end)

                    require("snacks").picker({
                        title = "File Browser: " .. dir,
                        items = entries,
                        win = {
                            input = {
                                keys = {
                                    ["<Tab>"] = {
                                        function(picker, item, action)
                                            if item and item.dir then
                                                picker:close()
                                                browse_directory(item.file)
                                            elseif item then
                                                picker:close()
                                                vim.cmd("edit " .. vim.fn.fnameescape(item.file))
                                            end
                                        end,
                                        mode = { "n", "i" }
                                    },
                                    ["<C-h>"] = {
                                        function(picker, item, action)
                                            if item and not item.dir then
                                                picker:close()
                                                vim.cmd("edit " .. vim.fn.fnameescape(item.file))
                                            else
                                                -- Go to parent directory
                                                local parent = vim.fn.fnamemodify(dir, ":h")
                                                if parent ~= dir then
                                                    picker:close()
                                                    browse_directory(parent)
                                                end
                                            end
                                        end,
                                        mode = { "n", "i" }
                                    },
                                    ["<CR>"] = {
                                        function(picker, item, action)
                                            if item and item.dir then
                                                picker:close()
                                                browse_directory(item.file)
                                            elseif item then
                                                picker:close()
                                                vim.cmd("edit " .. vim.fn.fnameescape(item.file))
                                            end
                                        end,
                                        mode = { "n", "i" }
                                    },
                                },
                            },
                        },
                    })
                end

                browse_directory(current_dir)
            end
            file_browser()
        end, desc = "File Browser" },
        { "<leader>E", function()
            local function file_browser(start_dir)
                local current_dir = start_dir or vim.fn.expand('%:p:h')
                if current_dir == '' then
                    current_dir = vim.loop.cwd()
                end

                local function browse_directory(dir)
                    local uv = vim.loop
                    local entries = {}

                    -- Add parent directory entry if not at root
                    if dir ~= "/" and dir ~= "\\" and not dir:match("^%a:[\\/]?$") then
                        table.insert(entries, {
                            text = "../",
                            file = vim.fn.fnamemodify(dir, ":h"),
                            is_dir = true,
                        })
                    end

                    -- Read directory contents
                    local handle = uv.fs_scandir(dir)
                    if handle then
                        while true do
                            local name, type = uv.fs_scandir_next(handle)
                            if not name then break end

                            local full_path = dir .. (dir:match("[\\/]$") and "" or "/") .. name
                            -- Use same logic as snacks explorer
                            local is_dir = type == "directory" or (type == "link" and vim.fn.isdirectory(full_path) == 1)

                            table.insert(entries, {
                                text = name,
                                file = full_path,
                                dir = is_dir,
                            })
                        end
                    end

                    -- Sort: directories first, then files
                    table.sort(entries, function(a, b)
                        if a.dir and not b.dir then return true end
                        if not a.dir and b.dir then return false end
                        return a.text < b.text
                    end)

                    require("snacks").picker({
                        title = "File Browser: " .. dir,
                        items = entries,
                        win = {
                            input = {
                                keys = {
                                    ["<Tab>"] = {
                                        function(picker, item, action)
                                            if item and item.dir then
                                                picker:close()
                                                browse_directory(item.file)
                                            elseif item then
                                                picker:close()
                                                vim.cmd("edit " .. vim.fn.fnameescape(item.file))
                                            end
                                        end,
                                        mode = { "n", "i" }
                                    },
                                    ["<C-h>"] = {
                                        function(picker, item, action)
                                            if item and not item.dir then
                                                picker:close()
                                                vim.cmd("edit " .. vim.fn.fnameescape(item.file))
                                            else
                                                -- Go to parent directory
                                                local parent = vim.fn.fnamemodify(dir, ":h")
                                                if parent ~= dir then
                                                    picker:close()
                                                    browse_directory(parent)
                                                end
                                            end
                                        end,
                                        mode = { "n", "i" }
                                    },
                                    ["<CR>"] = {
                                        function(picker, item, action)
                                            if item and item.dir then
                                                picker:close()
                                                browse_directory(item.file)
                                            elseif item then
                                                picker:close()
                                                vim.cmd("edit " .. vim.fn.fnameescape(item.file))
                                            end
                                        end,
                                        mode = { "n", "i" }
                                    },
                                },
                            },
                        },
                    })
                end

                browse_directory(current_dir)
            end
            file_browser(vim.loop.cwd())
        end, desc = "File Browser (CWD)" },
    },
    opts = {
        styles = {
            terminal = {
                position = "right"
            },
        },
        picker = {
            -- layout = "borderless_top",
            layouts = {
                borderless_top = {
                    layout = {
                        box = "horizontal",
                        backdrop = false,
                        width = 0.95,
                        heigh = 0.8,
                        border = "none",
                        {
                            box = "vertical",
                            { win = "input", height = 2, border = "none", title = "{title} {live} {flags}", title_pos = "center" },
                            { win = "list", title = " Results ", title_pos = "center", border = "none" },
                        },
                        {
                            win = "preview",
                            title = "{preview:Previw",
                            width = 0.6,
                            border = "none",
                            title_pos = "center",
                        }
                    }
                }
            },
            win = {
                input = {
                    keys = {
                        ["<C-l>"] = { "confirm", mode = { "n", "i" } },
                    },
                },
            }
        },
        dashboard = { enabled = require("utils.util").not_firenvim() }
    },
}
