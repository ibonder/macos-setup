return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "FzfLua",
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
    { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
    { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
    { "<leader>fh", "<cmd>FzfLua helptags<CR>", desc = "Help tags" },
    { "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
    { "<leader>fd", "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Diagnostics" },
    { "<leader>fw", "<cmd>FzfLua grep_cword<CR>", desc = "Grep word under cursor" },
    { "<leader>fc", "<cmd>FzfLua files cwd=~/.config/nvim<CR>", desc = "Find in nvim config" },
    { "<leader><leader>", "<cmd>FzfLua files<CR>", desc = "Find files" },
  },
  opts = {
    winopts = { height = 0.85, width = 0.85, preview = { layout = "vertical" } },
  },
}
