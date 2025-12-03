vim.g.mapleader = " "

vim.keymap.set("n", "<leader>so", "<CMD>w<CR><CMD>so<CR>", { desc = "Shout out the current file" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down & center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up & center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next instance & center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous instance & center" })
vim.keymap.set("n", "E", "$", { desc = "Move to end" })
vim.keymap.set("n", "B", "^", { desc = "Move to beginning" })
vim.keymap.set("n", "<ESC>", "<CMD>nohl<CR>", { desc = "Remove highlights" })
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

vim.keymap.set(
	"n",
	"<leader>rp",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move left" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move right" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move down" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move up" })

vim.keymap.set("n", "<leader>e", ":Oil<CR>", { desc = "Explorer" })

local ok, tb = pcall(require, "telescope.builtin")
if not ok then
	return
end
vim.keymap.set("n", "<leader>sa", tb.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>sf", tb.git_files, { desc = "Git files" })
vim.keymap.set("n", "<leader>sg", tb.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>sb", tb.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>sh", tb.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>sk", tb.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sc", tb.colorscheme, { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>sw", function()
	local word = vim.fn.expand("<cword>")
	tb.grep_string({ search = word })
end, { desc = "Search word under cursor" })
vim.keymap.set("n", "<leader>sW", function()
	local word = vim.fn.expand("<cWORD>")
	tb.grep_string({ search = word })
end, { desc = "Search WORD under cursor" })

vim.keymap.set("n", "<leader>tt", "<CMD>Trouble diagnostics toggle<CR>", { desc = "Toggle Trouble" })
vim.keymap.set("n", "[t", "<CMD>Trouble diagnostics prev<CR>", { desc = "Previous Trouble" })
vim.keymap.set("n", "]t", "<CMD>Trouble diagnostics next<CR>", { desc = "Next Trouble" })

vim.keymap.set({ "n", "v" }, "<leader>ks", function()
	require("kulala").run()
end, { desc = "Kulala (Send Request)" })
vim.keymap.set({ "n", "v" }, "<leader>ka", function()
	require("kulala").run_all()
end, { desc = "Kulala (Send All Requests)" })
vim.keymap.set({ "n", "v" }, "<leader>kr", function()
	require("kulala").replay()
end, { desc = "Kulala (Replay)" })

vim.g.tmux_navigator_no_mappings = 1

vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>")
vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>")
