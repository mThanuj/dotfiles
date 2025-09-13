require("mThanuj.set")
require("mThanuj.remap")
require("mThanuj.lazy_init")

local augroup = vim.api.nvim_create_augroup
local mThanujGroup = augroup("mThanuj", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {},
})

autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		if ft == "java" then
			vim.lsp.buf.format()
		else
			require("conform").format({ bufnr = args.buf })
		end
	end,
})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = mThanujGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("BufEnter", {
	group = mThanujGroup,
	callback = function()
		pcall(vim.cmd.colorscheme, "rose-pine-moon")
	end,
})

autocmd("LspAttach", {
	group = mThanujGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<leader>ws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>rr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>rn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_prev()
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_next()
		end, opts)
		vim.keymap.set("n", "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, opts)
	end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
