-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.winbar = "%=%m %f"

local opt = vim.opt

opt.number = true -- show line numbers
opt.relativenumber = true -- relative line numbers
opt.wrap = false -- no wrap
opt.updatetime = 300 -- faster CursorHold
opt.clipboard = "unnamedplus" -- use system clipboard for all yank, delete, paste operations

-- if you prefer the vim.o API, you could instead write:
-- vim.o.clipboard = "unnamedplus"
