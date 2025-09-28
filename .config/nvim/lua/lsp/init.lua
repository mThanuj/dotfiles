local cmp_lsp = require("cmp_nvim_lsp")
local capabilities =
	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

local mason_data_path = vim.fn.stdpath("data")

vim.lsp.enable({ "lua_ls", "ts_ls", "angularls", "pyright", "html", "omnisharp", "jdtls" })

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	},
})
vim.lsp.config("ts_ls", {
	capabilities = capabilities,
})
vim.lsp.config("angularls", {
	capabilities = capabilities,
})
vim.lsp.config("pyright", {
	capabilities = capabilities,
	cmd = { mason_data_path .. "/mason/bin/pyright", "--stdio" },
})
vim.lsp.config("html", {
	capabilities = capabilities,
})
vim.lsp.config("omnisharp", {
	capabilities = capabilities,
	cmd = {
		mason_data_path .. "/mason/packages/omnisharp/OmniSharp",
		"--languageserver",
		"--hostPID",
		tostring(vim.fn.getpid()),
	},
})
vim.lsp.config("jdtls", {
	settings = {
		java = {},
	},
})
