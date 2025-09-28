local lazy = require("lazy")

if not vim.g._lazy_setup_done then
	lazy.setup({
		spec = {
			{ import = "plugins" },
		},
		change_detection = {
			notify = false,
		},
	})
	vim.g._lazy_setup_done = true
end

return lazy
