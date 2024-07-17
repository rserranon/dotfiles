-- ~/.config/nvim/lua/plugins/ufo.lua
return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
      require("ufo").setup({
        provider_selector = function(bufnr, filetype)
          -- Use LSP if available, otherwise fallback to Treesitter
          if filetype == "lua" then
            return { "lsp", "treesitter" }
          elseif filetype == "cpp" or filetype == "c" then
            return { "lsp", "treesitter" }
          else
            return { "treesitter", "indent" }
          end
        end,
      })
    end,
  },
}
