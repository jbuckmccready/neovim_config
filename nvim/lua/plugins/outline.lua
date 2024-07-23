return {
	"hedyhli/outline.nvim",
	keys = {
		-- lazy load when toggled
		{ "<leader>o", "<cmd>Outline<CR>", mode = "n", desc = "Toggle Symbols Outline" },
	},
	config = function()
		require("outline").setup()
	end,
}
