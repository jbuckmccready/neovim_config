return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	keys = {
		{
			"<leader>t",
			"<cmd>Neotree toggle reveal_force_cwd<CR>",
			mode = "n",
			desc = "Toggle File Tree"
		},
	},
	cmd = {
		"Neotree",
	},
	config = function()
		require("neo-tree").setup({
			window = {
				mappings = {
					["<space>"] = "none",
					["h"] = "toggle_node",
				}
			},
		})
	end,
}
