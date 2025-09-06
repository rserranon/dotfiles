-- ~/.config/nvim/lua/plugins/json.lua
return {
  -- 1) Treesitter: JSON + JSON with comments
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for _, lang in ipairs({ "json", "jsonc" }) do
        if not vim.tbl_contains(opts.ensure_installed, lang) then
          table.insert(opts.ensure_installed, lang)
        end
      end
    end,
  },

  -- 2) Mason-LSPConfig: make sure jsonls is installed
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "jsonls") then
        table.insert(opts.ensure_installed, "jsonls")
      end
    end,
  },

  -- 3) JSON LSP with SchemaStore (validation + completion)
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/schemastore.nvim" },
    opts = {
      setup = {
        jsonls = function()
          local lspconfig = require("lspconfig")
          local schemastore = require("schemastore")

          lspconfig.jsonls.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              json = {
                schemas = schemastore.json.schemas(),
                validate = { enable = true },
                format = { enable = true },
              },
            },
          })
          -- tell LazyVim we've handled jsonls ourselves
          return true
        end,
      },
    },
  },

  -- 4) OPTIONAL: quick JSON/YAML explorer (use :JqxList)
  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "jsonc", "yaml" }, -- lazy-load only on these types
  },
}
