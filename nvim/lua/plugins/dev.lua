if false then
    return {}
end

return {
    {
        "JonLD/jot.nvim",
        dev = false,
        cmd = { -- Add commands for lazy loading
            "JotBranch",
            "JotProject",
            "JotOpen",
        },
        keys = {
            {
                "<leader>jj",
                function ()
                    require("jot").open_branch_note()
                end,
                desc = "Open Jot Branch Note",
            },
            {
                "<leader>jJ",
                function ()
                    require("jot").open_branch_note({use_cwd = true})
                end,
                desc = "Open Jot Branch Note",
            },
            {
                "<leader>jp",
                function ()
                    require("jot").open_project_note()
                end,
                desc = "Open Jot Project Note",
            },
            {
                "<leader>jP",
                function ()
                    require("jot").open_project_note({use_cwd = true})
                end,
                desc = "Open Jot Project Note",
            },
        },
    },
    {
        "2kabhishek/nerdy.nvim",
        dependencies = {
            'folke/snacks.nvim',
        },
        cmd = "Nerdy",
    },
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<leader>pu", desc = "Upload",
                    icon = { icon = " ", color = "cyan" }
                },
                {
                    "<leader>pb",
                    desc = "Build",
                    icon = { icon = "󰇺 ", color = "cyan" }
                },
                {
                    "<leader>pl",
                    desc = "generate compile commands",
                    icon = { icon = " ", color = "orange" }
                },
                {
                    "<leader>pi",
                    desc = "Initialise Project",
                    icon = { icon = " ", color = "green" }
                },
                {
                    "<leader>pc",
                    desc = "Clean",
                    icon = { icon = " ", color = "red" }
                },
                {
                    "<leader>pt",
                    desc = "Terminal",
                    icon = { icon = " ", color = "red" }
                },
                {
                    "<leader>pm",
                    desc = "Monitor",
                },
                {
                    "<leader>pl",
                    desc = "Lib search",
                   icon = { icon = " ", color = "green" }

                },
                {
                    "<leader>pd",
                    desc = "Debug",
                   icon = { icon = " ", color = "red" }
                },
                {
                    "<leader>pe",
                    desc = "Select Env",
                   icon = { icon = " ", color = "blue" }
                },
                { "<leader>p", group = "PlatformIO", icon = { icon = " ", color = "orange" } },
            },
        },
    },
    {
        "JonLD/platformio.nvim",
        enabled = false,
        dev = true,
        lazy = true,
        cmd = {
            "Pio",
            "Piorun",
            "Piodb",
            "Pioinit",
            "Piocmd",
            "Piomon",
            "Piolib",
            "Piodebug",
            "Pioenv",
        },
        keys = {
            {
                "<leader>pu",
                "<cmd>Piorun upload<CR>",
                desc = "Upload",
            },
            {
                "<leader>pb",
                "<cmd>Piorun build<CR>",
                desc = "Build",
            },
            {
                "<leader>pl",
                "<cmd>Piodb<CR>",
                desc = "generate compile commands",
            },
            {
                "<leader>pi",
                "<cmd>Pioinit<CR>",
                desc = "Initialise Project",
            },
            {
                "<leader>pc",
                "<cmd>Piorun clean<CR>",
                desc = "Clean",
            },
            {
                "<leader>pt",
                "<cmd>Piocmd<CR>",
                desc = "Terminal",
            },
            {
                "<leader>pm",
                "<cmd>Piomon<CR>",
                desc = "Monitor",
            },
            {
                "<leader>pl",
                "<cmd>Piolib<CR>",
                desc = "Lib search",
            },
            {
                "<leader>pd",
                "<cmd>Piodebug<CR>",
                desc = "Debug",
            },
            {
                "<leader>pe",
                "<cmd>Pioenv<CR>",
                desc = "Select Env",
            },
        },
    },
    {
        "JonLD/darkmodern.nvim",
        dev = true,
        enabled = false,
    },
    {
        "jon.lloyddavies/versius.nvim",
        dev = true,
        enabled = true,
        dependencies = { "stevearc/overseer.nvim" },
        cmd = {
            "VersiusTraceOpen",
            "VersiusTraceHover",
            "VersiusMake",
            "VersiusMakeCwd",
            "VersiusSystemUpdate",
            "VersiusNetcoms",
            "VersiusGenCompileCommands",
            "VersiusRemoteConnect",
            "VersiusRemoteDisconnect",
            "VersiusRemoteSync",
            "VersiusRemoteTerminal",
            "VersiusRemoteRunTest",
            "VersiusRemoteSyncShellConfig",
            "VersiusRemoteInstallShell",
            "VersiusRemoteBrowse",
            "VersiusRemoteCopyKey",
            "VersiusYankSvtPath",
            "VersiusTeamCityAgents",
            "VersiusTeamCityReenable",
            "VersiusRemoteCheckout",
        },
        keys = {
            { "gx", "<cmd>VersiusTraceOpen<cr>", desc = "Open URL, trace, or Jira ticket" },
            -- Versius
            { "<leader>v",   group = "Versius", icon = { icon = "󰢛 ", color = "blue" } },
            -- Apps
            { "<leader>va",   group = "Apps", icon = { icon = "󰢛 ", color = "blue" } },
            { "<leader>vas", "<cmd>VersiusSystemUpdate<cr>",          desc = "Run system update tool" },
            { "<leader>van", "<cmd>VersiusNetcoms<cr>",               desc = "Run netcoms" },
            -- Make
            { "<leader>vm",  group = "Make", icon = { icon = "󰛕 ", color = "yellow" } },
            { "<leader>vml", "<cmd>VersiusMakeCwd labpc<cr>",         desc = "make labpc" },
            { "<leader>vmi", "<cmd>VersiusMake ipxe<cr>",             desc = "make ipxe" },
            { "<leader>vmb", "<cmd>VersiusMake build<cr>",            desc = "make build" },
            { "<leader>vmc", "<cmd>VersiusMake clean<cr>",            desc = "make clean" },
            { "<leader>vmt", "<cmd>VersiusMake unit_test<cr>",        desc = "make unit_test" },
            { "<leader>vmk", "<cmd>VersiusMake klocwork<cr>",         desc = "make klocwork" },
            { "<leader>vmf", "<cmd>VersiusSvtMake format<cr>",         desc = "make klocwork" },
            { "<leader>vmg", "<cmd>VersiusGenCompileCommands<cr>",    desc = "Generate compile commands" },
            -- TeamCity
            { "<leader>vt",  group = "TeamCity" },
            { "<leader>vtt",  "<cmd>VersiusTeamCityAgents<cr>",     desc = "TeamCity agents" },
            { "<leader>vtr",  "<cmd>VersiusTeamCityReenable<cr>",  desc = "Re-enable my TeamCity agents" },
            -- Remote
            { "<leader>vy",  "<cmd>VersiusYankSvtPath<cr>",        desc = "Yank SVT path" },
            { "<leader>vr",  group = "Remote", icon = { icon = "󰢹 ", color = "cyan" } },
            { "<leader>vc", "<cmd>VersiusRemoteConnect<cr>",    desc = "Connect to remote host" },
            { "<leader>vrd", "<cmd>VersiusRemoteDisconnect<cr>", desc = "Disconnect from remote" },
            { "<leader>vro", "<cmd>VersiusRemoteCheckout<cr>",  desc = "Checkout local branch on remote" },
            { "<leader>vrs", "<cmd>VersiusRemoteSync<cr>",       desc = "Sync current file to remote" },
            { "<leader>vv", "<cmd>VersiusRemoteTerminal<cr>",  desc = "Open terminal on remote host" },
            { "<leader>vrr", "<cmd>VersiusRemoteRunTest<cr>",        desc = "Run SVT test on remote host" },
            { "<leader>vrb", "<cmd>VersiusRemoteBrowse<cr>",          desc = "Browse remote files" },
        },
        opts = {
            remote = {
                shell = "nu",
                shell_install_cmd = "choco install nushell -y --source https://community.chocolatey.org/api/v2/",
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            table.insert(opts.sections.lualine_x, 1, {
                function()
                    return require("versius.remote").statusline()
                end,
                color = { fg = "#7dcfff" },
            })
            return opts
        end,
    },
}
