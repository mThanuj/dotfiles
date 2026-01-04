local o = vim.opt

o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.omnifunc = ""
o.wrap = false
o.ignorecase = true
o.smartcase = true
o.cursorline = true

o.fileignorecase = true
o.hlsearch = true
o.incsearch = true
o.wrapscan = true

o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.expandtab = true
o.smarttab = true
o.autoindent = true
o.smartindent = true

o.guicursor = ""
o.swapfile = false
o.laststatus = 0
o.winborder = "rounded"
o.termguicolors = true
o.undofile = true
o.scrolloff = 8

o.isfname:append("@-@")

o.updatetime = 50

o.colorcolumn = "100"

vim.diagnostic.config({
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
	virtual_text = true,
})
