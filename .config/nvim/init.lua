vim.env.DOTNET_ROOT = "/usr/share/dotnet"
vim.env.PATH = vim.env.PATH .. ":" .. vim.env.DOTNET_ROOT

require("options")

require("plugins")

require("plugin_configs")

require("lsp_setups")

require("keymaps")

require("autocmds")

vim.cmd("colorscheme vague")
