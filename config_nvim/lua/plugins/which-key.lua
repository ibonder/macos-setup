return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>d", group = "diagnostics" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
    },
  },
}
