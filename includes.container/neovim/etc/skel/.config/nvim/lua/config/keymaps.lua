-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Switch Buffers
vim.keymap.set({ "n", "v", "i" }, "<C-h>", ":bprevious<CR>", { desc = "Switch to previous buffer" })
vim.keymap.set({ "n", "v", "i" }, "<C-l>", ":bnext<CR>", { desc = "Switch to next buffer" })

-- Move to the beginning and end of the line
vim.keymap.set({ "n", "v", "o" }, "H", "^", { desc = "Move to the beginning of the line" })
vim.keymap.set({ "n", "v", "o" }, "L", "g_", { desc = "Move to the end of the line" })

-- Save file
vim.api.nvim_set_keymap("n", "<leader>fs", ":w<CR>", { desc = "Save file", noremap = true })

-- Reflow paragraph
vim.keymap.set({ "n", "i" }, "<M-q>", "gwip", { desc = "Reflow paragraph" })
