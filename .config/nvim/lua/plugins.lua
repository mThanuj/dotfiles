vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mfussenegger/nvim-jdtls" },

	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/folke/trouble.nvim" },

	{ src = "https://github.com/mfussenegger/nvim-lint" },

	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/hrsh7th/cmp-cmdline" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },

	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },

	{ src = "https://github.com/mistweaverco/kulala.nvim" },

	{ src = "https://github.com/vague-theme/vague.nvim" },

	{ src = "https://github.com/j-hui/fidget.nvim" },

	{ src = "https://github.com/folke/lazydev.nvim" },

	{ src = "https://github.com/Hancho7/spring-properties-lsp.nvim" }, -- make the DEBUG=false in plugin file

	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/stevearc/oil.nvim" },

	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = vim.version.range("3") },

	{ src = "https://github.com/seblyng/roslyn.nvim", name = "roslyn.nvim" },

	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
})
