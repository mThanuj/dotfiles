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
