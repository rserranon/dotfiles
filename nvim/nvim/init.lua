-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.o.cursorcolumn = true
vim.api.nvim_set_hl(0, "CursorColumn", { ctermbg = 0, bg = "#3c3836", fg = "#ebdbb2" })
