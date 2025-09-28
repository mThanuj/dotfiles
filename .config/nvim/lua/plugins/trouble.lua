return {
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				icons = {
					indent = {
						middle = " ",
						last = " ",
						top = " ",
						ws = "│  ",
					},
				},
			})

			vim.keymap.set("n", "<leader>tt", "<CMD>Trouble diagnostics toggle<CR>", { desc = "Toggle Trouble" })

			vim.keymap.set("n", "[t", "<CMD>Trouble diagnostics prev<CR>", { desc = "Previous Trouble" })
			vim.keymap.set("n", "]t", "<CMD>Trouble diagnostics next<CR>", { desc = "Next Trouble" })
		end,
	},
}
