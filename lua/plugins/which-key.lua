return {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
      windows = false, -- default bindings on <c-w>
      spec = {
        {
          "<leader>w",
          group = "windows",
          { "<leader>wh", "<C-w>h", desc = "Go to Left Window" },
          { "<leader>wj", "<C-w>j", desc = "Go to Lower Window" },
          { "<leader>wk", "<C-w>k", desc = "Go to Upper Window" },
          { "<leader>wl", "<C-w>l", desc = "Go to Right Window" },
          { "<leader>wd", "<C-w>c", desc = "Delete Window" },
          { "<leader>wo", "<C-w>o", desc = "Delete Other Windows" },
          { "<leader>ww", "<C-w>w", desc = "Other Window" },
          { "<leader>wq", "<C-w>q", desc = "Quit Window" },
          { "<leader>wr", "<C-w>r", desc = "Rotate Windows" },
          { "<leader>wt", "<C-w>T", desc = "Move to New Tab" },
          { "<leader>w=", "<C-w>=", desc = "Equally Size Windows" },
          { "<leader>ws", "<C-w>s", desc = "Split Window Below" },
          { "<leader>wv", "<C-w>v", desc = "Split Window Right" },
          { "<leader>wH", "<C-w>H", desc = "Move Window Far Left" },
          { "<leader>wJ", "<C-w>J", desc = "Move Window Far Down" },
          { "<leader>wK", "<C-w>K", desc = "Move Window Far Up" },
          { "<leader>wL", "<C-w>L", desc = "Move Window Far Right" },
        },
      },
    },
}
