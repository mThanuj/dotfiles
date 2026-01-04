return {
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		config = function()
			local luasnip = require("luasnip")
			luasnip.setup({})
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"rafamadriz/friendly-snippets",
	},
}
