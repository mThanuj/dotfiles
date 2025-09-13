return {
	"nanotee/sqls.nvim",
	config = function()
		vim.lsp.config("sqls", {})
		vim.lsp.enable("sqls")
	end,
}
