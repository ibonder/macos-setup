local servers = {
  "bashls",
  "dockerls",
  "gopls",
  "helm_ls",
  "jsonls",
  "lua_ls",
  "terraformls",
  "yamlls",
}

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = { spacing = 2, prefix = "●" },
        severity_sort = true,
        float = { border = "rounded", source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
      })

      -- Kubernetes/CI schema validation, and keep yamlls off Helm templates
      -- (those are filetype=helm, handled by helm_ls).
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            validate = true,
            keyOrdering = false,
            schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses = { unusedparams = true, nilness = true },
            staticcheck = true,
          },
        },
      })

      -- mason-lspconfig v2 enables each installed server itself.
      require("mason-lspconfig").setup({ ensure_installed = servers })
    end,
  },

  -- Makes lua_ls understand the `vim` global and plugin sources when editing
  -- this config.
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
    },
  },
}
