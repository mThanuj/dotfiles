return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({})

		vim.keymap.set("n", "H", "<CMD>BufferLineCyclePrev<CR>", {})
		vim.keymap.set("n", "L", "<CMD>BufferLineCycleNext<CR>", {})
		vim.keymap.set("n", "<leader>bo", "<CMD>BufferLineCloseOthers<CR>", {})
		vim.keymap.set("n", "<leader>bc", "<CMD>BufferLinePickClose<CR>", {})
		vim.keymap.set("n", "<leader>bp", "<CMD>BufferLinePick<CR>", {})
		vim.keymap.set("n", "<leader>bd", "<CMD>bdelete<CR>", {})
	end,
}
