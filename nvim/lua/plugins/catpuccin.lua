-- ~/.config/nvim/lua/plugins/catppuccin.lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        -- custom configurations can go here
      })
      -- Set colorscheme
      vim.cmd("colorscheme catppuccin")
    end,
  },
}
