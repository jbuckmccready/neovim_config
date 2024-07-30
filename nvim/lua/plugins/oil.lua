return {
	'stevearc/oil.nvim',
	keys = {
		{ "<Leader>F", "<cmd>Oil<CR>", mode = "n", desc = "Open Oil File Edit" },
	},
	config = function()
		require('oil').setup()
	end,
}
