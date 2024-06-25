return {
  "norcalli/nvim-colorizer.lua", -- Specify the plugin repository
  config = function()
    require("colorizer").setup(
      { "*" }, -- Enable for all file types
      {
        RGB = true, -- Enable #RGB hex codes
        RRGGBB = true, -- Enable #RRGGBB hex codes
        names = true, -- Enable color names like 'Blue'
        RRGGBBAA = true, -- Enable #RRGGBBAA hex codes
        rgb_fn = true, -- Enable rgb() and rgba() functions
        hsl_fn = true, -- Enable hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      }
    )
  end,
}
