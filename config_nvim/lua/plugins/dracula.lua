return {
  {
    "maxmx03/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("dracula").setup({
        transparent = false,
        plugins = {
          ["nvim-treesitter"] = true,
          ["nvim-lspconfig"] = true,
          ["nvim-tree.lua"] = true,
          ["which-key.nvim"] = true,
          ["dashboard-nvim"] = true,
          ["gitsigns.nvim"] = true,
          ["neogit"] = true,
          ["lazy.nvim"] = true,
        },
      })
      vim.cmd.colorscheme("dracula-soft")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "dracula",
        globalstatus = true,
        refresh = { statusline = 1000 },
      },
    },
  },
}
