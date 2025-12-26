local cmp_lsp = require("cmp_nvim_lsp")
local capabilities =
	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

local mason_data_path = vim.fn.stdpath("data")

local on_attach = function(_, bufnr)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = "LSP: " .. desc })
	end

	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Actions")

	map("n", "gd", vim.lsp.buf.definition, "Go to Definition")

	map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")

	map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")

	map("n", "gt", vim.lsp.buf.type_definition, "Go to Type Definition")

	map("n", "K", vim.lsp.buf.hover, "Show Hover Documentation")

	map("i", "<C-k>", vim.lsp.buf.signature_help, "Show Signature Help")

	map("n", "gr", vim.lsp.buf.references, "Go to References")

	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Actions")

	map("n", "<leader>d", vim.diagnostic.open_float, "Show Buffer Diagnostics")

	map("n", "<leader>rn", vim.lsp.buf.rename, "LSP Rename")

	map("n", "]d", function()
		vim.diagnostic.jump({ count = 1 })
	end, "Next Diagnostic")

	map("n", "[d", function()
		vim.diagnostic.jump({ count = -1 })
	end, "Previous Diagnostic")
end

vim.lsp.enable({
	"lua_ls",
	"ts_ls",
	"angularls",
	"pyright",
	"html",
	"jdtls",
	"lemminx",
	"prismals",
	"tailwindcss",
	"dockerls",
	"docker_compose_language_service",
	"cssls",
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
vim.lsp.config("cssls", {
	capabilities = capabilities,
	on_attach = on_attach,
})
vim.lsp.config("dockerls", {
	capabilities = capabilities,
	on_attach = on_attach,
})
vim.lsp.config("docker_compose_language_service", {
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
	cmd = { mason_data_path .. "/mason/bin/pyright-langserver", "--stdio" },
	on_attach = on_attach,
})
vim.lsp.config("html", {
	capabilities = capabilities,
	on_attach = on_attach,
})
vim.lsp.config("jdtls", {
	settings = {
		java = {
			configuration = {
				runtimes = {
					{
						name = "JavaSE-25",
						path = "/usr/lib/jvm/java-25-openjdk",
						default = true,
					},
				},
			},
		},
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
