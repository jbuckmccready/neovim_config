require('config.lazy')

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require('cmp')
cmp.setup({
	preselect = cmp.PreselectMode.None,
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		-- Add tab support
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
	},

	-- Installed sources
	sources = {
		{ name = "nvim_lsp" },
		{ name = "vsnip" },
		{ name = "path" },
		{ name = "buffer" },
	},
	-- Border window for visual clarity
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})

-- using mason for lsp setup
require("mason").setup()
-- mason-lspconfig just to simplify setup of lsp
require("mason-lspconfig").setup()
-- go lsp
require("lspconfig").gopls.setup {}
-- lua lsp
require("lspconfig").lua_ls.setup {
	-- setup copied from here: https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua
	on_init = function(client)
		-- some setup to eliminate warnings when editing neovim lua files
		-- only override for neovim lua config files if no .luarc.json defined
		local path = client.workspace_folders[1].name
		if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT'
			},
			diagnostics = {
				-- Get the language server to recognize additional neovim globals
				globals = { 'bufnr', 'au_group' },
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths here.
					"${3rd}/luv/library",
					-- "${3rd}/busted/library",
				}
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			}
		})
	end,
	settings = {
		Lua = {}
	}
}

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option_value('updatetime', 10, {})


-- Rust specific setup (note: rustaceanvim uses nvim lsp under the hood)
vim.keymap.set('n', '<leader>od', function() vim.cmd.RustLsp('openDocs') end, { silent = true })
vim.keymap.set("n", "<leader>d", ":Gitsigns preview_hunk<CR>")

vim.g.rustaceanvim = {
	-- Plugin configuration
	tools = {
		-- Don't run clippy on save
		enable_clippy = false,
	},
	-- LSP configuration
	server = {
		on_attach = {},
		capabilities = {},
		default_settings = {
			-- rust-analyzer language server configuration
			['rust-analyzer'] = {
				rustfmt = {
					-- nightly rust fmt
					extraArgs = { '+nightly' },
				},
			},
		},
	},
	-- DAP configuration
	dap = {
	},
}

-- lsp format on save
vim.api.nvim_create_autocmd('BufWritePre', {
	group = au_group,
	buffer = bufnr,
	callback = function()
		vim.lsp.buf.format({
			timeout_ms = 2000,
			async = false,
		})
	end,
})

-- Turn on/off lsp inlay hints
vim.lsp.inlay_hint.enable(false)

-- Status bar setup
require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = '|',
		section_separators = '',
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		-- path = 2 for absolute file path
		lualine_c = { { 'filename', path = 2 } },
		lualine_x = { 'lsp_progress', 'encoding', 'fileformat', 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_d = {},
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}


-- Exit terminal mode with ctrl-w hjkl buffer navigation
vim.keymap.set('t', '<C-w>h', "<C-\\><C-n><C-w>h", { silent = true })
vim.keymap.set('t', '<C-w>j', "<C-\\><C-n><C-w>j", { silent = true })
vim.keymap.set('t', '<C-w>k', "<C-\\><C-n><C-w>k", { silent = true })
vim.keymap.set('t', '<C-w>l', "<C-\\><C-n><C-w>l", { silent = true })
--
-- Exit terminal mode with escape
vim.keymap.set('t', '<Esc>', "<C-\\><C-n>", { silent = true })

-- Enter terminal mode immediately
-- not sure if I like it, disabled for now
-- vim.api.nvim_create_autocmd({"BufWinEnter", "WinEnter"}, {
--   pattern = {"term://*"},
--   callback = function()
--     vim.cmd("startinsert")
--   end
-- })

-- Tab setup
-- navigation
vim.keymap.set('n', '<leader>h', "gT", { silent = true })
vim.keymap.set('n', '<leader>l', "gt", { silent = true })
vim.keymap.set('n', '<leader>1', "1gt", { silent = true })
vim.keymap.set('n', '<leader>2', "2gt", { silent = true })
vim.keymap.set('n', '<leader>3', "3gt", { silent = true })
vim.keymap.set('n', '<leader>4', "4gt", { silent = true })
vim.keymap.set('n', '<leader>5', "5gt", { silent = true })
vim.keymap.set('n', '<leader>6', "6gt", { silent = true })
vim.keymap.set('n', '<leader>7', "7gt", { silent = true })
vim.keymap.set('n', '<leader>8', "8gt", { silent = true })
vim.keymap.set('n', '<leader>9', "9gt", { silent = true })
vim.keymap.set('n', '<leader>9', "9gt", { silent = true })
-- creation
vim.keymap.set('n', '<leader>n', function() vim.cmd(":tab split") end, {})


-- Code navigation and shortcuts
vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gD", vim.lsp.buf.implementation, {})
vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, {})
vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, {})
-- using telescope
-- vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, {})
vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})

-- lsp rename
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, {})
-- lsp code action
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, {})
-- RustLsp codeAction creates grouping if available and different interface if desired
-- vim.keymap.set("n", "ga", function() vim.cmd.RustLsp('codeAction') end, keymap_opts)

-- Hop setup
local hop = require('hop')
local directions = require('hop.hint').HintDirection

-- Telescope file browser setup
vim.keymap.set("n", "<leader>b", ":Telescope file_browser<CR>")
require("telescope").load_extension "file_browser"
-- Telescope fzf extension for performance on fuzzy searching
require('telescope').load_extension('fzf')

vim.keymap.set({ 'n', 'o', 'v' }, 'f',
	function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true }) end,
	{ remap = true })
vim.keymap.set({ 'n', 'o', 'v' }, 'F',
	function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true }) end,
	{ remap = true })
vim.keymap.set({ 'n', 'o', 'v' }, 't',
	function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 }) end,
	{ remap = true })
vim.keymap.set({ 'n', 'o', 'v' }, 'T',
	function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 }) end,
	{ remap = true })
vim.keymap.set({ 'n', 'o', 'v' }, 's',
	function() hop.hint_words({ direction = directions.AFTER_CURSOR, current_line_only = false }) end,
	{ remap = true })
vim.keymap.set({ 'n', 'o', 'v' }, 'S',
	function() hop.hint_words({ direction = directions.BEFORE_CURSOR, current_line_only = false }) end,
	{ remap = true })


-- Neogit setup
vim.keymap.set('n', '<leader>g', function() require('neogit').open({}) end, {})

-- Neotree setup
vim.keymap.set("n", "<leader>t", ":Neotree<CR>")


-- have a fixed column for the diagnostics to appear in
-- this removes the jitter/shift right when warnings/errors flow in
vim.wo.signcolumn = "yes"
-- show line numbers
vim.wo.number = true
-- colorscheme
vim.cmd.colorscheme "catppuccin"
