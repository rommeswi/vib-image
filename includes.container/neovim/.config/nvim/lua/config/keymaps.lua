-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({"n", "o"}, "gh", "^", { desc = "Go to line beginning" })
vim.keymap.set({"n", "o"}, "gl", "$", { desc = "Go to line end" })
vim.keymap.set({"n", "o"}, "<A-h>", "gl", "^")
vim.keymap.set({"n", "o"}, "<A-l>", "gl", "$")
