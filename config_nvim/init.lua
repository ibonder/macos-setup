-- nvim-tree requires netrw to be disabled before anything else loads.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Must be set before lazy.nvim loads so plugin `keys` specs resolve correctly.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.lazy")
