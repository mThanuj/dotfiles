vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-jdtls" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/mistweaverco/kulala.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/hrsh7th/cmp-cmdline" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/Exafunction/windsurf.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("vague").setup({
	transparent = true,
})
require("oil").setup({})
require("telescope").setup({})
require("kulala").setup({
	ui = {
		win_opts = {
			wo = { foldmethod = "manual" },
		},
		display_mode = "float",
	},
	lsp = {
		enable = true,
		formatter = {
			sort = {
				metadata = true,
				variables = true,
				commands = true,
				json = false,
			},
		},
	},
})
require("mason").setup()
require("mason-lspconfig").setup({
	automatic_enable = {
		exclude = {
			"jdtls",
		},
	},
})
require("nvim-treesitter.config").setup({
	auto_install = true,
	highlight = { enable = true },
	install_dir = vim.fn.stdpath("data") .. "/site/pack/packer/start/treesitter",
})
require("harpoon"):setup({})
require("fidget").setup({})
require("codeium").setup({
	enable_cmp_source = false,
	virtual_text = {
		enabled = true,

		manual = false,
		filetypes = {},
		default_filetype_enabled = true,
		idle_delay = 50,
		virtual_text_priority = 65535,
		map_keys = true,
		accept_fallback = nil,
		key_bindings = {
			accept = "<Tab>",
			accept_word = false,
			accept_line = false,
			clear = false,
			next = "<M-]>",
			prev = "<M-[>",
		},
	},
})

require("luasnip").setup({})
require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
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
		xml = { "xmlformatter" },
		java = { "google-java-format" },
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

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.omnifunc = ""

vim.opt.wrap = false
vim.opt.wrapscan = true

vim.opt.ignorecase = true
vim.opt.fileignorecase = true
vim.opt.smartcase = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.guicursor = ""
vim.opt.swapfile = false
vim.opt.winborder = "rounded"
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.scrolloff = 8

vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

vim.diagnostic.config({
	virtual_text = true,
})

vim.keymap.set("n", "<leader>so", "<CMD>w<CR><CMD>so<CR>", { desc = "Source file" })
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open Explorer" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste global clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to global clipboard" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format buffer" })
vim.keymap.set(
	"n",
	"<leader>rp",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move left" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move right" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move down" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move up" })

vim.keymap.set("n", "<Esc>", "<CMD>nohl<CR>", { desc = "Clear highlight" })

vim.keymap.set("n", "B", "^", { desc = "Move to beginning of line" })
vim.keymap.set("n", "E", "$", { desc = "Move to end of line" })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sa", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>sf", builtin.git_files, { desc = "Git files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help tags in neovim" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sc", builtin.colorscheme, { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>sw", function()
	local word = vim.fn.expand("<cword>")
	builtin.grep_string({ search = word })
end, { desc = "Search word under cursor" })
vim.keymap.set("n", "<leader>sW", function()
	local word = vim.fn.expand("<cWORD>")
	builtin.grep_string({ search = word })
end, { desc = "Search WORD under cursor" })

vim.keymap.set({ "n", "v" }, "<leader>ks", function()
	require("kulala").run()
end, { desc = "Kulala (Send Request)" })
vim.keymap.set({ "n", "v" }, "<leader>ka", function()
	require("kulala").run_all()
end, { desc = "Kulala (Send All Requests)" })
vim.keymap.set({ "n", "v" }, "<leader>kr", function()
	require("kulala").replay()
end, { desc = "Kulala (Replay)" })

local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<M-1>", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<M-2>", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<M-3>", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<M-4>", function()
	harpoon:list():select(4)
end)

vim.keymap.set("n", "<C-S-P>", function()
	harpoon:list():prev()
end)
vim.keymap.set("n", "<C-S-N>", function()
	harpoon:list():next()
end)

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show Hover Documentation" })
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Show Signature Help" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show Buffer Diagnostics" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })

vim.lsp.enable({
	"lua_ls",
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

vim.cmd([[colorscheme vague]])
vim.cmd([[:hi statusline guibg=None]])
