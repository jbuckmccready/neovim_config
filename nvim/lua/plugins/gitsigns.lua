return {
	'lewis6991/gitsigns.nvim',
	keys = {
		{ "<leader>gn", "<cmd>Gitsigns next_hunk<CR>",  mode = "n", desc = "Next Diff Hunk" },
		{ "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>",  mode = "n", desc = "Prev Diff Hunk" },
		{ "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", mode = "n", desc = "Reset Diff Hunk" },
	},
	lazy = false,
	opts = {
		current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
			delay = 50,
			ignore_whitespace = false,
			virt_text_priority = 100,
		},
	}
}
