return {
    {
        "JonLD/snacks-file-browser.nvim",
        dev = true,
        dependencies = { "folke/snacks.nvim" },
        cmd = { "FileBrowser", "FileBrowserCwd" },
        keys = {
            { "<leader>e",  "<CMD>FileBrowser<CR>", desc = "File Browser" },
            { "<leader>E", "<CMD>FileBrowserCwd<CR>", desc = "File Browser (CWD)" },
        },
    },
    {
        "folke/snacks.nvim",
        keys = {
            { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
            { "<leader>sb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
            {
                "<leader>fb",
                function()
                    local base
                    for _, ref in ipairs({ "origin/HEAD", "origin/main", "origin/master" }) do
                        local out = vim.trim(vim.fn.system("git merge-base HEAD " .. ref))
                        if vim.v.shell_error == 0 and out ~= "" then
                            base = out
                            break
                        end
                    end
                    if not base then
                        Snacks.notify.warn("Could not determine branch base")
                        return
                    end
                    local files = vim.fn.systemlist("git diff --name-only " .. base .. " HEAD")
                    if #files == 0 then
                        Snacks.notify.info("No changed files on branch")
                        return
                    end
                    Snacks.picker.pick({
                        title = "Branch Changed Files",
                        items = vim.tbl_map(function(f) return { file = f, text = f } end, files),
                        format = "file",
                    })
                end,
                desc = "Branch Changed Files",
            },
            {
                "<leader>fj",
                function()
                    local base
                    for _, ref in ipairs({ "origin/HEAD", "origin/main", "origin/master" }) do
                        local out = vim.trim(vim.fn.system("git merge-base HEAD " .. ref))
                        if vim.v.shell_error == 0 and out ~= "" then
                            base = out
                            break
                        end
                    end
                    if not base then
                        Snacks.notify.warn("Could not determine branch base")
                        return
                    end
                    local files = vim.fn.systemlist("git diff --name-only " .. base .. " HEAD")
                    if #files == 0 then
                        Snacks.notify.info("No changed files on branch")
                        return
                    end
                    for _, f in ipairs(files) do
                        vim.cmd("edit " .. vim.fn.fnameescape(f))
                    end
                    Snacks.notify.info("Opened " .. #files .. " changed files")
                end,
                desc = "Open All Branch Changed Files",
            },
            { "<leader>sf", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
            { "<leader>N", function() Snacks.notifier.show_history() end, desc = "Notification History" },
        },
        opts = {
            lazygit = {
                configure = false,
            },
            styles = {
                terminal = {
                    position = "right",
                },
            },
            picker = {
                ui_select = true,
                -- layout = "borderless_top",
                formatters = {
                    file = {
                        filename_first = true,
                    },
                },
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
            dashboard = { enabled = require("utils.util").not_firenvim() },
            scroll = {
                animate = {
                    duration = { step = 10, total = 100 },
                    easing = "linear",
                },
            },
        },}
}
