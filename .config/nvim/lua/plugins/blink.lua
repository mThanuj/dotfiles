return {
	"Saghen/blink.cmp",
	event = "InsertEnter",
	build = "cargo build --release",
	dependencies = { "L3MON4D3/LuaSnip" },
	config = function()
		local blink = require("blink.cmp")
		local luasnip = require("luasnip")

		blink.setup({
			keymap = { preset = "enter" },
			snippets = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { documentation = { auto_show = true, auto_show_delay_ms = 500 } },
			signature = { enabled = true },
		})

		-- local opts = { silent = true, expr = true, replace_keycodes = false }

		-- -- Tab / Shift-Tab snippet navigation
		-- vim.api.nvim_set_keymap("i", "<Tab>",
		--     "luasnip.expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", opts)
		-- vim.api.nvim_set_keymap("s", "<Tab>",
		--     "luasnip.expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", opts)
		-- vim.api.nvim_set_keymap("i", "<S-Tab>", "luasnip.jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'", opts)
		-- vim.api.nvim_set_keymap("s", "<S-Tab>", "luasnip.jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'", opts)
	end,
}
