local opt = vim.opt

-- Indentation: 2 spaces, matching the yaml/terraform/helm this box mostly edits.
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftround = true
opt.smartindent = true

-- Go and Makefiles want real tabs.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "make" },
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = true
opt.linebreak = true
opt.textwidth = 0
opt.colorcolumn = "100"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.termguicolors = true

-- Splits open where you expect them to.
opt.splitright = true
opt.splitbelow = true

-- Persistent undo across sessions; no swap/backup clutter.
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Share the system clipboard.
opt.clipboard = "unnamedplus"

-- Faster CursorHold events (gitsigns, diagnostics) and a shorter which-key delay.
opt.updatetime = 250
opt.timeoutlen = 400

opt.confirm = true
opt.mouse = "a"

-- Helm templates are Go templates, not YAML — stops yaml-language-server from
-- flagging every {{ }} block as a syntax error.
vim.filetype.add({
  pattern = {
    [".*/templates/.*%.ya?ml"] = "helm",
    [".*/templates/.*%.tpl"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
  },
})
