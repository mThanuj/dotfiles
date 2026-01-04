return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.config").setup({
			ensure_installed = { "lua", "javascript", "typescript" },
			auto_install = true,
			highlight = { enable = true },
		})
	end,
}
