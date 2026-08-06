return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
    { "<leader>E", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal file in tree" },
  },
  opts = {
    view = { width = 34 },
    renderer = { group_empty = true },
    filters = { dotfiles = false, custom = { "^%.git$" } },
    git = { enable = true },
  },
}
