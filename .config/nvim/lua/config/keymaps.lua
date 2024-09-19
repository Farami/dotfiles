local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Diagnostics
--keymap.set("n", "<C-j>", function()
--	vim.diagnostic.goto_next()
-- end, opts)

keymap.set("n", "<leader>r", function()
	require("craftzdog.utils").replaceHexWithHSL()
end)

keymap.set("n", "<leader>cg", function()
	local copilot_status = vim.g.copilot_enabled
	if copilot_status then
		vim.cmd(":Copilot disable")
		vim.g.copilot_enabled = false
		vim.notify("Copilot Disabled", vim.log.levels.INFO)
	else
		vim.cmd(":Copilot enable")
		vim.g.copilot_enabled = true
		vim.notify("Copilot Enabled", vim.log.levels.INFO)
	end
end, { desc = "Toggle Copilot" })
