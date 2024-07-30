return {
	"christoomey/vim-tmux-navigator",
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
	},
	keys = {
		{ "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>",     desc = "Navigate left" },
		{ "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>",     desc = "Navigate down" },
		{ "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>",       desc = "Navigate up" },
		{ "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>",    desc = "Navigate right" },
		{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate previous" },
	},
}
