return {
	'tpope/vim-fugitive',
	keys = {
		{ "<leader>gg", "<cmd>Git<CR>",               mode = "n", desc = "Git Status" },
		{ "<leader>gl", "<cmd>Git log --oneline<CR>", mode = "n", desc = "Commit Log" },
	},
	lazy = false
}
