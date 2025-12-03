require("vague").setup({
	transparent = true,
})

require("fidget").setup({})

require("telescope").setup({ defaults = {} })

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})
require("mason-lspconfig").setup({
	automatic_enable = {
		exclude = {
			"jdtls",
		},
	},
})

require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	}),
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "javascript", "typescript", "java", "prisma" },
	auto_install = true,
	highlight = { enable = true },
	sync_install = false,
	modules = {},
	ignore_install = {},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		python = { "isort", "black" },
		html = { "prettierd" },
		cs = { "csharpier" },
		xml = { "xmlformatter" },
	},
	format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
	formatters = {
		["clang-format"] = {
			-- LLVM, GNU, Google, Chromium, Microsoft, Mozilla, WebKit
			args = {
				"--style={BasedOnStyle: Google, IndentWidth: 4}",
			},
		},
		xmlformatter = {
			command = "xmlformat",
			args = {
				"--indent",
				"4",
				"--overwrite",
				"--blanks",
				"-",
			},
		},
	},
})

require("trouble").setup({
	icons = {
		indent = {
			middle = " ",
			last = " ",
			top = " ",
			ws = "│  ",
		},
	},
})

require("oil").setup({
	default_file_explorer = true,
	watch_for_changes = true,
})

require("neo-tree").setup({
	-- options go here
})

local cmp_lsp = require("cmp_nvim_lsp")
local capabilities =
	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
local on_attach = function(_, bufnr)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = "LSP: " .. desc })
	end

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

	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Actions")
end
local ok, roslyn = pcall(require, "roslyn")
if ok then
	roslyn.setup({
		-- Neovim 0.12 Recommendation: Enable filewatching
		filewatching = true,

		-- All standard LSP config goes inside this 'config' table
		config = {
			capabilities = capabilities,
			on_attach = on_attach,

			root_dir = function(fname)
				local root =
					vim.fs.dirname(vim.fs.find({ ".sln", ".csproj", ".git" }, { upward = true, path = fname })[1])
				return root or vim.fn.getcwd()
			end,

			settings = {
				["csharp|inlay_hints"] = {
					csharp_enable_inlay_hints_for_implicit_object_creation = true,
					csharp_enable_inlay_hints_for_implicit_variable_types = true,
					csharp_enable_inlay_hints_for_types = true,
				},
				["csharp|code_lens"] = {
					dotnet_enable_references_code_lens = true,
				},
			},
		},

		-- OPTIONAL: If Mason doesn't auto-detect the path, you can force it here.
		-- (Only needed if :LspInfo shows the server isn't found)
		-- cmd = {
		--    "roslyn",
		--    "--stdio",
		--    "--logLevel=Information",
		--    "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
		--    "--razorSourceGenerator=" .. vim.fs.joinpath(vim.fn.stdpath("data") .. "/mason/packages/roslyn/libexec/Microsoft.CodeAnalysis.Razor.Compiler.dll"),
		--    "--razorDesignTimePath=" .. vim.fs.joinpath(vim.fn.stdpath("data") .. "/mason/packages/roslyn/libexec/Targets/Microsoft.NET.Sdk.Razor.DesignTime.targets"),
		-- }
	})
end
