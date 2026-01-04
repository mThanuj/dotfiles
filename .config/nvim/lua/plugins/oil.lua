return {
	"stevearc/oil.nvim",
	cmd = "Oil",
	config = function()
		require("oil").setup({
			skip_confirm_for_simple_edits = true,
			prompt_save_on_select_new_entry = false,
			watch_for_changes = true,
		})
	end,
}
