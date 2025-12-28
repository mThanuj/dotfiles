vim.g.mapleader = " "

-- OPTIONS
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.confirm = true
vim.opt.signcolumn = "yes"
vim.opt.guicursor = ""
vim.opt.laststatus = 0
vim.opt.winborder = "rounded"
vim.opt.termguicolors = true
vim.opt.isfname:append("@-@")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.linebreak = true
vim.opt.wildoptions:append({ "fuzzy" })
vim.opt.path:append({ "**" })
vim.opt.scrolloff = 10
vim.opt.smoothscroll = true
vim.opt.statusline = "[%n] %<%f %h%w%m%r%=%-14.(%l,%c%V%) %P"
vim.opt.colorcolumn = "100"
vim.opt.cursorline = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25

vim.diagnostic.config({
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
	virtual_text = true,
})

vim.filetype.add({
	extension = {
		properties = "properties",
		http = "http",
	},
})

-- PACK
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/Producdevity/wakatime.nvim",
	"https://github.com/vague-theme/vague.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/mfussenegger/nvim-jdtls",
	"https://github.com/mfussenegger/nvim-lint",
	"https://github.com/mistweaverco/kulala.nvim",
	"https://github.com/Hancho7/spring-properties-lsp.nvim",
})

-- KEYMAPS
vim.keymap.set("n", "<ESC>", "<CMD>nohl<CR>")
vim.keymap.set("n", "<leader>so", "<CMD>so ~/dotfiles/.config/nvim/init.lua<CR>")

vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")

vim.keymap.set("n", "E", "$")
vim.keymap.set("n", "B", "^")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p')

vim.keymap.set("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		if vim.fn.complete_info().selected ~= -1 then
			return "<C-y>"
		else
			return "<CR><CR>"
		end
	end
	return "<CR>"
end, { expr = true })

local kulala = require("kulala")
vim.keymap.set({ "n", "v" }, "<leader>ks", function()
	kulala.run()
end, { desc = "Kulala (Send Request)" })
vim.keymap.set({ "n", "v" }, "<leader>ka", function()
	kulala.run_all()
end, { desc = "Kulala (Send All Requests)" })
vim.keymap.set({ "n", "v" }, "<leader>kr", function()
	kulala.replay()
end, { desc = "Kulala (Replay)" })

-- LSP
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

vim.lsp.enable("basedpyright")
vim.lsp.enable("lua_ls")
vim.lsp.enable("jdtls")
vim.lsp.enable("angularls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("tailwindcss")

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	},
})
vim.lsp.config("tailwindcss", {
	on_attach = on_attach,
})
vim.lsp.config("basedpyright", {
	on_attach = on_attach,
})
vim.lsp.config("ts_ls", {
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
vim.lsp.config("angularls", {
	on_attach = on_attach,
})

-- PLUGINS
local treesitter = require("nvim-treesitter")
treesitter.install({ "lua", "java", "python" }):wait(300000)

local wakatime = require("wakatime")
wakatime.setup({
	debug = false,
})

local vague = require("vague")
vague.setup({
	transparent = true,
})

local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		python = { "isort", "black" },
		html = { "prettierd" },
		xml = { "xmlformatter" },
	},
	format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
	formatters = {
		["clang-format"] = {
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

-- AUTOCMDS
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.o.signcolumn = "yes:1"
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/completion") then
			vim.o.complete = "o,.,w,b,u"
			vim.opt.completeopt = "fuzzy,menu,menuone,popup,noinsert,noselect"
			vim.lsp.completion.enable(true, client.id, args.buf)
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

local lint = require("lint")

local function safe_lint()
	local ft = vim.bo.filetype
	local buftype = vim.bo.buftype

	if buftype ~= "" then
		return
	end

	if lint.linters_by_ft[ft] then
		lint.try_lint()
	end
end

vim.api.nvim_create_autocmd("InsertLeave", {
	callback = safe_lint,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	callback = safe_lint,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "properties" },
	callback = function()
		local ok, lsp = pcall(require, "spring-properties-lsp")
		if ok then
			lsp.setup({
				debug = false,
			})
		end
	end,
	once = true,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "http" },
	callback = function()
		local ok, lsp = pcall(require, "kulala")
		if ok then
			lsp.setup({
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
		end
	end,
	once = true,
})

-- COMMANDS
vim.cmd([[
aunmenu PopUp
autocmd! nvim.popupmenu
]])
vim.cmd("syntax off")
vim.cmd("colorscheme vague")
