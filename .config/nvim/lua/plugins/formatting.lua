return {
	"stevearc/conform.nvim",
	dependencies = { "mason-org/mason.nvim" },
	event = "BufWritePre",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				python = { "isort", "black" },
				html = { "prettierd" },
				cs = { "clang-format" },
			},
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
			formatters = {
				["clang-format"] = {
					-- LLVM, GNU, Google, Chromium, Microsoft, Mozilla, WebKit
					args = {
						"--style={BasedOnStyle: Google, IndentWidth: 4}",
					},
				},
			},
		})
	end,
}
