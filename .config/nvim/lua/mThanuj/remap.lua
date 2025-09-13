vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { noremap = true, desc = "Open Oil file explorer" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, desc = "Move down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, desc = "Move up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Merge current line with next" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down one page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up one page" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Jump to next match" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Jump to previous match" })
vim.keymap.set("n", "<leader>lsp", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Remove default Q mapping" })

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Jump to next quickfix" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Jump to previous quickfix" })
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz", { desc = "Jump to next location" })
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz", { desc = "Jump to previous location" })

-- Create a dedicated group for our autocommands
local ts_js_keymaps_group = vim.api.nvim_create_augroup("TSJSKeymaps", { clear = true })

-- Run organize imports automatically on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = ts_js_keymaps_group,
	pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
	callback = function()
		vim.lsp.buf.execute_command({
			command = "_typescript.organizeImports",
			arguments = { vim.api.nvim_buf_get_name(0) },
		})
	end,
})

vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end, { desc = "Source current file" })
