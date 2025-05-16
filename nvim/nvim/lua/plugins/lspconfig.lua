return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      pyright = function(_, opts)
        opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
          python = {
            venvPath = vim.fn.stdpath("data") .. "/envs",
            venv = ".venv",
            defaultInterpreterPath = ".venv/bin/python",
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              reportMissingTypeStubs = false,
              diagnosticMode = "workspace",
            },
          },
        })
        require("lspconfig").pyright.setup(opts)
        return true
      end,
      rust_analyzer = function()
        return true
      end,
    },
  },
}
