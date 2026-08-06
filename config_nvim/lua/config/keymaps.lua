local map = vim.keymap.set

-- Plugin-specific maps live in their own specs under lua/plugins so lazy.nvim
-- can use them as load triggers. Only editor-level maps belong here.

-- Clear search highlight.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window navigation.
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Buffers.
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Keep the selection when re-indenting.
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move selected lines.
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Paste over a selection without clobbering the unnamed register.
map("x", "p", [["_dP]], { desc = "Paste without yanking" })

-- Diagnostics.
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Write / quit.
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })

-- Lazy UI.
map("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy" })

-- Neovim 0.11+ already provides the LSP maps: K (hover), grn (rename),
-- gra (code action), grr (references), gri (implementation), gO (symbols).
