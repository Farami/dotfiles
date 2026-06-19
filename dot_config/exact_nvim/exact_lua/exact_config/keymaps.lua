-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Cursor CLI mappings
vim.keymap.set("n", "<leader>cc", ":CursorChat<CR>")
vim.keymap.set("n", "<leader>ce", ":CursorEdit<CR>")
vim.keymap.set("v", "<leader>ce", ":CursorEdit<CR>")
vim.keymap.set("n", "<leader>cg", ":CursorGenerate<CR>")
vim.keymap.set("v", "<leader>cx", ":CursorExplain<CR>")
vim.keymap.set("n", "<leader>cr", ":CursorReview<CR>")
vim.keymap.set("v", "<leader>co", ":CursorOptimize<CR>")
vim.keymap.set("v", "<leader>cf", ":CursorFix<CR>")
vim.keymap.set("v", "<leader>crf", ":CursorRefactor<CR>")
