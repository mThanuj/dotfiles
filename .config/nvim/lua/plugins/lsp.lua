return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		config = function()
			require("mason").setup({})
		end,
	},
	{ "neovim/nvim-lspconfig" },
}
