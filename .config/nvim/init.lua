-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("core.options")

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	change_detection = {
		notify = false,
	},
})

-- Core configs
require("core.keymaps")
require("core.autocmds")

-- LSP
require("lsp")

local COLORS = {
	ROSE_PINE = "rose-pine",
	ROSE_PINE_MOON = "rose-pine-moon",
	TOKYONIGHT = "tokyonight",
	CATPPUCCIN = "catppuccin",
	VAGUE = "vague",
}

local function is_valid_color(color)
	for _, c in pairs(COLORS) do
		if c == color then
			return true
		end
	end
	return false
end

function ColorMyPencils(color)
	color = color or COLORS.ROSE_PINE_MOON

	if not is_valid_color(color) then
		vim.notify("Invalid colorscheme: " .. tostring(color), vim.log.levels.ERROR)
		return
	end

	vim.cmd.colorscheme(color)

	vim.cmd("hi statusline guibg=NONE")
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils(COLORS.ROSE_PINE_MOON)
vim.cmd("set completeopt+=menu,menuone,noselect")
