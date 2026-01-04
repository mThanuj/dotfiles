return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	opts = {
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
	},
}
