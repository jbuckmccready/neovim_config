return {
	'kevinhwang91/nvim-ufo',
	dependencies = 'kevinhwang91/promise-async',
	config = function()
		-- Using ufo provider need remap `zR`, `zM`, `zr`, and `zm`.
		vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "Open all folds" })
		vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "Close all folds" })
		vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = "Open folds except" })
		vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = "Close folds with" })

		vim.o.foldcolumn = "0"
		vim.o.foldlevel = 99 -- Using ufo provider need a large value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
		vim.o.fillchars = [[fold: ,foldopen:,foldsep: ,foldclose:]]

		require("ufo").setup(
			{
				provider_selector = function()
					return { "treesitter", "indent" }
				end
			}
		)
	end
}
