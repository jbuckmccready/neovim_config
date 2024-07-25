return {
	'jakewvincent/mkdnflow.nvim',
	ft = 'markdown',
	config = function()
		require('mkdnflow').setup(
			{
				mappings = {
					-- turn on insert mode MkdnEnter for auto list bullet creation on <CR>
					MkdnEnter = { { 'n', 'v', 'i' }, '<CR>' },
				}
			}
		)
	end
}
