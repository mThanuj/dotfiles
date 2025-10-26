local map = vim.keymap.set

map("n", "<leader>so", "<CMD>w<CR><CMD>so<CR>", { desc = "Shout out the current file" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down & center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up & center" })
map("n", "n", "nzzzv", { desc = "Next instance & center" })
map("n", "N", "Nzzzv", { desc = "Previous instance & center" })
map("n", "E", "$", { desc = "Move to end" })
map("n", "B", "^", { desc = "Move to beginning" })
map("n", "<ESC>", "<CMD>nohl<CR>", { desc = "Remove highlights" })
map({ "n", "v", "x" }, "<leader>y", '"+y<CR>', { desc = "Yank to system clipboard" })
map({ "n", "v", "x" }, "<leader>p", '"+p<CR>', { desc = "Paste from system clipboard" })

local ok, tb = pcall(require, "telescope.builtin")
if not ok then
	return
end
map("n", "<leader>sa", tb.find_files, { desc = "Find files" })
map("n", "<leader>sf", tb.git_files, { desc = "Git files" })
map("n", "<leader>sg", tb.live_grep, { desc = "Live grep" })
map("n", "<leader>sb", tb.buffers, { desc = "Buffers" })
map("n", "<leader>sh", tb.help_tags, { desc = "Help tags" })
map("n", "<leader>sk", tb.keymaps, { desc = "Keymaps" })
map("n", "<leader>sc", tb.colorscheme, { desc = "Colorschemes" })
map("n", "<leader>sw", function()
	local word = vim.fn.expand("<cword>")
	tb.grep_string({ search = word })
end, { desc = "Search word under cursor" })
map("n", "<leader>sW", function()
	local word = vim.fn.expand("<cWORD>")
	tb.grep_string({ search = word })
end, { desc = "Search WORD under cursor" })

map("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })

map("n", "<leader>ff", function()
	require("conform").format({ async = true })
end, { desc = "Format buffer" })

map("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

map("n", "<leader>lsp", "<CMD>LspRestart<CR>", { desc = "Restart all LSP clients" })

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move left" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move right" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move down" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move up" })

map({ "n", "v" }, "<leader>ks", function()
	require("kulala").run()
end, { desc = "Kulala (Send Request)" })
map({ "n", "v" }, "<leader>ka", function()
	require("kulala").run_all()
end, { desc = "Kulala (Send All Requests)" })
map({ "n", "v" }, "<leader>kr", function()
	require("kulala").replay()
end, { desc = "Kulala (Replay)" })

map("n", "<leader>rn", function()
	vim.lsp.buf.rename()
end, { desc = "Move up" })
