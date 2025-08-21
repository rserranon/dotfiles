return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      pyright = function(_, opts)
        print("Loading pyright configuration")
        opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
          python = {
            venvPath = vim.fn.stdpath("data") .. "/envs",
            venv = ".venv",
            defaultInterpreterPath = ".venv/bin/python",
            analysis = {
              typeCheckingMode = "off",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              reportMissingTypeStubs = false,
              reportUnknownMemberType = false,
              reportUnknownVariableType = false,
              reportUnknownArgumentType = false,
              reportGeneralTypeIssues = false,
              diagnosticMode = "openFiles",
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
