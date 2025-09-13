return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				java = { "google-java-format" },
				lua = { "stylua" },
				go = { "gofmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				elixir = { "mix" },
				html = { "prettier" },
				sql = { "pgformatter" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = { "-style=file", "-fallback-style=LLVM" },
				},
				["pgformatter"] = {
					command = "pg_format",
					args = { "-" },
					stdin = true,
				},
			},
		})
	end,
}
