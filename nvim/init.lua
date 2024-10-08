require('config.lazy')
require('config.patches')
require('config.keymappings')

local settings = require('config.settings')

-- Basics from mini plugins
require('mini.basics').setup({
	mappings = {
		basic = true,
		option_toggle_prefix = '\\',
		windows = true,
	}
})
require('mini.surround').setup()
require('mini.indentscope').setup({
	draw = {
		delay = 50,
		animation = function()
			return 0
		end,
	},
})
require('mini.bracketed').setup()
require('mini.ai').setup()

-- NOTE: `guess-indent` plugin will auto match existing file for indent settings so they are left default
local o = vim.o
-- smart/auto indent for new lines - seems to give best results but can also be autoindent = true or smartindent = true
o.cindent = true
-- Keep popup menus from being too tall (limit to 30 items)
o.pumheight = 30

-- Global settings
-- have a fixed column for the diagnostics to appear in
-- this removes the jitter/shift right when warnings/errors flow in
vim.wo.signcolumn = "yes"
-- show line numbers
vim.wo.number = true
-- colorscheme
vim.cmd.colorscheme(settings.colorscheme)
vim.o.background = settings.background
-- If nothing typed for this many milliseconds then swap file is written to disk (for crash recovery)
vim.api.nvim_set_option_value('updatetime', 750, {})

-- Hookup lsp status before attaching any lsp (to be used in status line)
require('lsp-status').register_progress()

-- using mason for lsp setup
require("mason").setup()
-- mason-lspconfig just to simplify setup of lsp
require("mason-lspconfig").setup()
-- go lsp
require("lspconfig").gopls.setup({})
-- lua lsp
require("lspconfig").lua_ls.setup({
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
})

require('lspconfig').zls.setup({})

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
					extraArgs = { settings.rust_fmt_extra_args },
				},
				-- increase limit to 1024 for searching across workspace (defaults to only 128)
				workspace = { symbol = { search = { limit = 1024 } } }
			},
		},
	},
	-- DAP configuration
	dap = {
	},
}

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp", { clear = true }),
	callback = function(args)
		-- lsp format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = args.buf,
			callback = function()
				vim.lsp.buf.format { async = false, id = args.data.client_id }
			end,
		})
	end
})

-- Turn off lsp inlay hints by default
vim.lsp.inlay_hint.enable(false)

-- Status line setup
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
			statusline = 500,
			tabline = 500,
			winbar = 500,
		}
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		-- path = 2 for absolute file path
		lualine_c = { { 'filename', path = 2 } },
		lualine_x = { 'require("lsp-status").status()', 'encoding', 'fileformat', 'filetype' },
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
