return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<C-a>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-w>",
			},
			ignore_filetypes = { markdown = true },
		})
	end,
}
