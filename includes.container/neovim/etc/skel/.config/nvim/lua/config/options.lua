-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- Detect GNOME color scheme so the correct tokyonight style loads at startup
local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
if handle then
  local scheme = handle:read("*a")
  handle:close()
  if scheme:match("prefer%-light") then
    vim.o.background = "light"
  end
end

vim.opt.textwidth = 80
vim.opt.colorcolumn = "80"

vim.opt.formatoptions = vim.opt.formatoptions + "t"

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
