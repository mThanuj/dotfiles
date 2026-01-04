return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"danarth/sonarlint.nvim",
		},

		config = function()
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
					{ name = "codeium" },
				}, {
					{ name = "buffer" },
				}),
			})

			require("sonarlint").setup({
				server = {
					cmd = {
						"sonarlint-language-server",
						"-stdio",
						"-analyzers",
						vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
						vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
						vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
					},
					settings = {
						sonarlint = {
							rules = {
								["typescript:S101"] = { level = "on", parameters = { format = "^[A-Z][a-zA-Z0-9]*$" } },
								["typescript:S103"] = { level = "on", parameters = { maximumLineLength = 180 } },
								["typescript:S106"] = { level = "on" },
								["typescript:S107"] = { level = "on", parameters = { maximumFunctionParameters = 7 } },
							},
						},
					},
				},
				filetypes = {
					"java",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		opts = {
			automatic_enable = {
				exclude = {
					"jdtls",
				},
			},
		},
	},
	{
		"mfussenegger/nvim-jdtls",
	},
	{
		"rafamadriz/friendly-snippets",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}
