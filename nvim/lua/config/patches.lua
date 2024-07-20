-- FIXME: workaround for https://github.com/neovim/neovim/issues/28058
-- Error pops up when opening .go files without this workaround
local make_client_capabilities = vim.lsp.protocol.make_client_capabilities
function vim.lsp.protocol.make_client_capabilities()
	local caps = make_client_capabilities()
	if not (caps.workspace or {}).didChangeWatchedFiles then
		vim.notify(
			'lsp capability didChangeWatchedFiles is already disabled',
			vim.log.levels.WARN
		)
	else
		caps.workspace.didChangeWatchedFiles = nil
	end

	return caps
end
