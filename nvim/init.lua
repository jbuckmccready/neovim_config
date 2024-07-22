require('config.lazy')
require('config.patches')
require('config.keymappings')

-- Basics from mini plugins
require('mini.basics').setup({
	mappings = {
		basic = true,
		option_toggle_prefix = '\\',
		windows = true,
	}
})
require('mini.surround').setup()
require('mini.pairs').setup()
require('mini.indentscope').setup({
	draw = {
		delay = 50,
		animation = function()
			return 0
		end,
	},
})
require('mini.bracketed').setup()


-- Global settings
-- have a fixed column for the diagnostics to appear in
-- this removes the jitter/shift right when warnings/errors flow in
vim.wo.signcolumn = "yes"
-- show line numbers
vim.wo.number = true
-- colorscheme
vim.cmd.colorscheme "catppuccin-mocha"
-- If nothing typed for this many milliseconds then swap file is written to disk (for crash recovery)
vim.api.nvim_set_option_value('updatetime', 750, {})

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
		["<up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
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

-- Hookup lsp status before attaching any lsp (to be used in status line)
local lsp_status = require('lsp-status')
lsp_status.register_progress()

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
				-- increase limit to 1024 for searching across workspace (defaults to only 128)
				workspace = { symbol = { search = { limit = 1024 } } }
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

-- Status line setup
local status_line = require('mini.statusline')
-- highlight for lsp loading status (change keys to style differently)
vim.api.nvim_set_hl(0, 'MiniStatuslineLspStatus', { default = true })
status_line.setup({
	content = {
		-- Content for active window
		active =
		    function()
			    local mode, mode_hl     = status_line.section_mode({ trunc_width = 120 })
			    local git               = status_line.section_git({ trunc_width = 40 })
			    local diff              = status_line.section_diff({ trunc_width = 75 })
			    local diagnostics       = status_line.section_diagnostics({ trunc_width = 75 })
			    local lsp               = status_line.section_lsp({ trunc_width = 75 })
			    local filename          = status_line.section_filename({ trunc_width = 140 })
			    local fileinfo          = status_line.section_fileinfo({ trunc_width = 120 })
			    local location          = status_line.section_location({ trunc_width = 75 })
			    local search            = status_line.section_searchcount({ trunc_width = 75 })

			    local lsp_status_string = lsp_status.status()

			    return status_line.combine_groups({
				    { hl = mode_hl,                 strings = { mode } },
				    { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
				    '%<', -- Mark general truncate point
				    { hl = 'MiniStatuslineFilename',  strings = { filename } },
				    '%=', -- End left alignment
				    { hl = 'MiniStatuslineLspStatus', strings = { lsp_status_string } },
				    { hl = 'MiniStatuslineFileinfo',  strings = { fileinfo } },
				    { hl = mode_hl,                   strings = { search, location } },
			    })
		    end,
		-- Content for inactive window(s)
		inactive = nil,
	},
	use_icons = true,
	set_vim_settings = true,
})

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
