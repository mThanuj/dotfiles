local cmp_lsp = require("cmp_nvim_lsp")
local capabilities =
	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

local mason_data_path = vim.fn.stdpath("data")

local on_attach = function(client, bufnr)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = "LSP: " .. desc })
	end

	map("n", "gd", vim.lsp.buf.definition, "Go to Definition")

	-- Go to Declaration
	map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")

	-- Go to Implementation
	map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")

	-- Go to Type Definition
	map("n", "gt", vim.lsp.buf.type_definition, "Go to Type Definition")

	-- Show hover documentation
	map("n", "K", vim.lsp.buf.hover, "Show Hover Documentation")

	-- Show signature help
	map("i", "<C-k>", vim.lsp.buf.signature_help, "Show Signature Help")

	-- Find all references
	map("n", "gr", vim.lsp.buf.references, "Go to References")

	-- Code actions (e.g., "quick fix")
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Actions")

	-- Show buffer diagnostics
	map("n", "<leader>d", vim.diagnostic.open_float, "Show Buffer Diagnostics")

	-- Go to the next diagnostic
	map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")

	-- Go to the previous diagnostic
	map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
end

vim.lsp.enable({
	"lua_ls",
	"ts_ls",
	"angularls",
	"pyright",
	"html",
	"omnisharp",
	"jdtls",
	"lemminx",
	"prismals",
	"tailwindcss",
})

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
	on_attach = on_attach,
})
vim.lsp.config("tailwindcss", {
	capabilities = capabilities,
	on_attach = on_attach,
})
vim.lsp.config("prismals", {
	capabilities = capabilities,
	on_attach = on_attach,
})
vim.lsp.config("angularls", {
	capabilities = capabilities,
	on_attach = on_attach,
})
vim.lsp.config("pyright", {
	capabilities = capabilities,
	cmd = { mason_data_path .. "/mason/bin/pyright", "--stdio" },
	on_attach = on_attach,
})
vim.lsp.config("html", {
	capabilities = capabilities,
	on_attach = on_attach,
})
vim.lsp.config("omnisharp", {
	capabilities = capabilities,
	cmd = {
		mason_data_path .. "/mason/packages/omnisharp/OmniSharp",
		"--languageserver",
		"--hostPID",
		tostring(vim.fn.getpid()),
	},
	on_attach = on_attach,
})
vim.lsp.config("jdtls", {
	settings = {
		java = {},
	},

	-- add this to .zshrc
	-- export JDTLS_JVM_ARGS="-javaagent:$HOME/dotfiles/lombok.jar -Xbootclasspath/a:$HOME/dotfiles/lombok.jar"

	on_attach = on_attach,
})
vim.lsp.config("lemminx", {
	settings = {
		java = {},
	},
	on_attach = on_attach,
})
