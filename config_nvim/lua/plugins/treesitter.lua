local languages = {
  "bash",
  "diff",
  "dockerfile",
  "git_config",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "hcl",
  "helm",
  "json",
  "jsonnet",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "python",
  "regex",
  "terraform",
  "toml",
  "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()

    -- The main branch installs on demand rather than via ensure_installed.
    local ok, installed = pcall(require("nvim-treesitter.config").get_installed, "parsers")
    if ok then
      local have = {}
      for _, parser in ipairs(installed) do
        have[parser] = true
      end
      local missing = vim.tbl_filter(function(lang)
        return not have[lang]
      end, languages)
      if #missing > 0 then
        require("nvim-treesitter").install(missing)
      end
    end

    -- Highlighting is opt-in per buffer on the main branch.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and pcall(vim.treesitter.start, args.buf, lang) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
