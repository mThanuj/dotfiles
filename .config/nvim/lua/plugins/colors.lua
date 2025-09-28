return {
	{
		"vague2k/vague.nvim",
		config = function()
			require("vague").setup({ transparent = true })
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				disable_background = true,
				styles = {
					italic = false,
				},
			})
		end,
	},
}
