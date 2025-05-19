-- lua/plugins/catppuccin.lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "macchiato",
      background = { light = "latte", dark = "macchiato" },
      transparent_background = true,
      term_colors = true,
      styles = {
        comments = { "italic" },
        keywords = { "bold" },
        functions = {}, -- leave empty if you don’t need special styles
        strings = {},
        variables = {},
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
