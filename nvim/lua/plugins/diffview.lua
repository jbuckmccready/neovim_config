return {
	"sindrets/diffview.nvim",
	keys = {
		-- lazy load when toggled
		{ "<leader>gd", "<cmd>DiffviewOpen<CR>",        mode = "n", desc = "Diff View All" },
		{ "<leader>gD", "<cmd>DiffviewOpen -uno<CR>",   mode = "n", desc = "Diff View Only Tracked" },
		{ "<leader>gf", "<cmd>DiffviewFileHistory<CR>", mode = "n", desc = "Diff View File History" },
	},
	config = function()
		require("diffview").setup()
	end
}
