require('config.lazy')
require('config.patches')
local miniclue = require('mini.clue')
miniclue.setup({
	window = {
		delay = 0,
		config = {
			width = 70,
		},
	},
	triggers = {
		-- leader triggers
		{ mode = 'n', keys = '<leader>' },
		{ mode = 'x', keys = '<leader>' },

		-- Built-in completion
		{ mode = 'i', keys = '<C-x>' },

		-- `g` key
		{ mode = 'n', keys = 'g' },
		{ mode = 'x', keys = 'g' },

		-- Marks
		{ mode = 'n', keys = "'" },
		{ mode = 'n', keys = '`' },
		{ mode = 'x', keys = "'" },
		{ mode = 'x', keys = '`' },

		-- Registers
		{ mode = 'n', keys = '"' },
		{ mode = 'x', keys = '"' },
		{ mode = 'i', keys = '<C-r>' },
		{ mode = 'c', keys = '<C-r>' },

		-- Window commands
		{ mode = 'n', keys = '<C-w>' },
		{ mode = 't', keys = '<C-w>' },

		-- `z` key
		{ mode = 'n', keys = 'z' },
		{ mode = 'x', keys = 'z' },
	},

	clues = {
		-- common
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers({ show_contents = true }),
		miniclue.gen_clues.windows({ submode_resize = true }),
		miniclue.gen_clues.z(),

		-- Telescope
		{ mode = 'n', keys = '<leader>f',  desc = 'Telescope' },

		-- Hop
		{ mode = 'n', keys = '<leader>s',  desc = 'Hop' },
		{ mode = 'o', keys = '<leader>s',  desc = 'Hop' },
		{ mode = 'v', keys = '<leader>s',  desc = 'Hop' },

		-- Code Editing
		{ mode = 'n', keys = '<leader>e',  desc = 'Code Editing' },
		{ mode = 'v', keys = '<leader>e',  desc = 'Code Editing' },

		-- Git
		{ mode = 'n', keys = '<leader>g',  desc = 'Git' },
		{ mode = 'n', keys = '<leader>gn', postkeys = '<leader>g' },
		{ mode = 'n', keys = '<leader>gp', postkeys = '<leader>g' },
	},
})
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
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<Tab>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
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

vim.keymap.set({ 'n' }, '<leader>od', function() vim.cmd.RustLsp('openDocs') end, { desc = 'Open Rust Doc' })

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

-- Telescope
-- Telescope fzf extension for performance on fuzzy searching
require('telescope').load_extension('fzf')
local actions = require("telescope.actions")
local copy_tele_selection = function()
	local entry = require("telescope.actions.state").get_selected_entry()
	-- honor clipboard settings
	local cb_opts = vim.opt.clipboard:get()
	if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", entry.path) end
	if vim.tbl_contains(cb_opts, "unnamedplus") then vim.fn.setreg("+", entry.path) end
	vim.fn.setreg("", entry.path)
end
require("telescope").setup {
	defaults = {
		mappings = {
			i = {
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<C-y>"] = copy_tele_selection,
			},
			n = {
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<C-y>"] = copy_tele_selection,
			},
		},
	},
	pickers = {
		buffers = {
			mappings = {
				i = {
					["<c-b>"] = actions.delete_buffer + actions.move_to_top,
				},
				n = {
					["<c-b>"] = actions.delete_buffer + actions.move_to_top,
				}
			}
		}
	}
}

local tele_builtin = require('telescope.builtin')
vim.keymap.set({ 'n' }, "<leader>ff", tele_builtin.find_files, { desc = "Find File" })
vim.keymap.set({ 'n' }, "<leader>fg", tele_builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set({ 'n' }, "<leader>fb", tele_builtin.buffers, { desc = "Find Buffer" })
vim.keymap.set({ 'n' }, "<leader>fz", tele_builtin.current_buffer_fuzzy_find, { desc = "Buffer Fuzzy Find" })
vim.keymap.set({ 'n' }, "<leader>fh", tele_builtin.help_tags, { desc = "Find Help" })
vim.keymap.set({ 'n' }, "<leader>fw", tele_builtin.grep_string, { desc = "Grep Word Under Cursor" })
vim.keymap.set({ 'n' }, "<leader>fr", tele_builtin.lsp_references, { desc = "Find References" })
vim.keymap.set({ 'n' }, "<leader>fs", tele_builtin.lsp_document_symbols, { desc = "Document Symbols" })
vim.keymap.set({ 'n' }, "<leader>fS", tele_builtin.lsp_workspace_symbols, { desc = "Workspace Symbols" })
vim.keymap.set({ 'n' }, "<leader>fq", tele_builtin.diagnostics, { desc = "LSP Diagnostics" })
vim.keymap.set({ 'n' }, "<leader>f:", tele_builtin.command_history, { desc = "Command History" })
vim.keymap.set({ 'n' }, "<leader>f/", tele_builtin.search_history, { desc = "Search History" })
vim.keymap.set({ 'n' }, "<leader>ft", tele_builtin.lsp_type_definitions, { desc = "Goto Type Definition(s)" })
vim.keymap.set({ 'n' }, "<leader>fd", tele_builtin.lsp_definitions, { desc = "Goto Definition(s)" })
vim.keymap.set({ 'n' }, "<leader>fi", tele_builtin.lsp_implementations, { desc = "Goto Implementation(s)" })
vim.keymap.set({ 'n' }, "<leader>f\"", tele_builtin.registers, { desc = "Registers" })
vim.keymap.set({ 'n' }, "<leader>f'", tele_builtin.marks, { desc = "Marks" })
vim.keymap.set({ 'n' }, "<leader>fG", tele_builtin.git_branches, { desc = "Git Branches" })
vim.keymap.set({ 'n' }, "<leader>fc", tele_builtin.git_bcommits, { desc = "Buffer Git Commits" })
vim.keymap.set({ 'n' }, "<leader>fC", tele_builtin.git_commits, { desc = "Git Commits" })
vim.keymap.set({ 'n' }, "<leader>fe", tele_builtin.git_status, { desc = "Git Status" })
vim.keymap.set({ 'n' }, "<leader>fl", tele_builtin.colorscheme, { desc = "Color Scheme" })

-- Terminal
-- Exit terminal mode with ctrl-w hjkl buffer navigation
vim.keymap.set({ "t" }, "<C-w>h", "<C-\\><C-n><C-w>h", { desc = "Focus left" })
vim.keymap.set({ "t" }, "<C-w>j", "<C-\\><C-n><C-w>j", { desc = "Focus down" })
vim.keymap.set({ "t" }, "<C-w>k", "<C-\\><C-n><C-w>k", { desc = "Focus up" })
vim.keymap.set({ "t" }, "<C-w>l", "<C-\\><C-n><C-w>l", { desc = "Focus right" })
-- Exit terminal mode with escape
vim.keymap.set({ "t" }, "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- Close window while in terminal mode
vim.keymap.set({ "t" }, "<C-w>q", "<C-\\><C-n><C-w>q", { desc = "Quit current" })
--

-- Enter terminal mode immediately
-- not sure if I like it, disabled for now
-- vim.api.nvim_create_autocmd({"BufWinEnter", "WinEnter"}, {
--   pattern = {"term://*"},
--   callback = function()
--     vim.cmd("startinsert")
--   end
-- })

-- Tab setup
vim.keymap.set({ "n" }, "<leader>h", "<cmd>tabprevious<CR>", { desc = "Next Tab" })
vim.keymap.set({ "n" }, "<leader>l", "<cmd>tabnext<CR>", { desc = "Previous Tab" })
vim.keymap.set({ "n" }, "<leader>H", "<cmd>tabfirst<CR>", { desc = "First Tab" })
vim.keymap.set({ "n" }, "<leader>L", "<cmd>tablast<CR>", { desc = "Last Tab" })
vim.keymap.set({ "n" }, "<leader>1", "<cmd>1tabnext<CR>", { desc = "Tab 1" })
vim.keymap.set({ "n" }, "<leader>2", "<cmd>2tabnext<CR>", { desc = "Tab 2" })
vim.keymap.set({ "n" }, "<leader>3", "<cmd>3tabnext<CR>", { desc = "Tab 3" })
vim.keymap.set({ "n" }, "<leader>4", "<cmd>4tabnext<CR>", { desc = "Tab 4" })
vim.keymap.set({ "n" }, "<leader>5", "<cmd>5tabnext<CR>", { desc = "Tab 5" })
vim.keymap.set({ "n" }, "<leader>n", "<cmd>tab split<CR>", { desc = "New Tab" })
vim.keymap.set({ "n" }, "<leader>c", "<cmd>tabc<CR>", { desc = "Close Tab" })

-- Code editing
vim.keymap.set({ "n" }, "<leader>er", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set({ "n", "v" }, "<leader>ea", require('actions-preview').code_actions, { desc = "Code Action" })

-- Misc. LSP
vim.keymap.set({ "n" }, "K", vim.lsp.buf.hover, { desc = "Hover Text" })

-- Hop setup
local hop = require('hop')
local directions = require('hop.hint').HintDirection

-- mimic the usual f, F, t, T mappings with hop variants
vim.keymap.set({ "n", "o", "v" }, "f", function() hop.hint_char1({ direction = directions.AFTER_CURSOR }) end,
	{ desc = "Hop 1Char After" })
vim.keymap.set({ "n", "o", "v" }, "F", function() hop.hint_char1({ direction = directions.BEFORE_CURSOR }) end,
	{ desc = "Hop 1Char Before" })
vim.keymap.set({ "n", "o", "v" }, "t",
	function() hop.hint_char1({ direction = directions.AFTER_CURSOR, hint_offset = -1 }) end,
	{ desc = "Hop 1Char After-1" })
vim.keymap.set({ "n", "o", "v" }, "T",
	function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, hint_offset = 1 }) end,
	{ desc = "Hop 1Char Before-1" })
-- hop to words
vim.keymap.set({ "n", "o", "v" }, "s", function() hop.hint_words({ direction = directions.AFTER_CURSOR }) end,
	{ desc = "Hop Word After" })
vim.keymap.set({ "n", "o", "v" }, "S", function() hop.hint_words({ direction = directions.BEFORE_CURSOR }) end,
	{ desc = "Hop Word Before" })

vim.keymap.set({ "n", "o", "v" }, "<leader>ss", function() hop.hint_lines({ multi_windows = true }) end,
	{ desc = "Hop Lines Global" })
vim.keymap.set({ "n", "o", "v" }, "<leader>sd", require('hop-treesitter').hint_nodes, { desc = "Hop Nodes" })
vim.keymap.set({ "n", "o", "v" }, "<leader>sv", function() hop.hint_vertical({ direction = directions.AFTER_CURSOR }) end,
	{ desc = "Hop Vertical After" })
vim.keymap.set({ "n", "o", "v" }, "<leader>sV",
	function() hop.hint_vertical({ direction = directions.BEFORE_CURSOR }) end, { desc = "Hop Vertical Before" })

-- Neotree setup
vim.keymap.set({ "n" }, "<leader>t", "<cmd>Neotree toggle<CR>", { desc = "Toggle File Tree" })

-- Git setup
vim.keymap.set({ "n" }, "<leader>gg", "<cmd>Git<CR>", { desc = "Status", })
vim.keymap.set({ "n" }, "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Diff Current File", })
vim.keymap.set({ "n" }, "<leader>gs", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Hunk Diff", })
vim.keymap.set({ "n" }, "<leader>gn", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next Hunk", })
vim.keymap.set({ "n" }, "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous Hunk", })
vim.keymap.set({ "n" }, "<leader>gl", "<cmd>Git log --oneline<CR>", { desc = "Commit Log", })


-- have a fixed column for the diagnostics to appear in
-- this removes the jitter/shift right when warnings/errors flow in
vim.wo.signcolumn = "yes"
-- show line numbers
vim.wo.number = true
-- colorscheme
vim.cmd.colorscheme "catppuccin-mocha"
