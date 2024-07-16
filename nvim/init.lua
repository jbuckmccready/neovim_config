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

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 10) 

-- Rust specific setup (note: rustaceanvim uses nvim lsp under the hood)
vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
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
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
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
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', 'lsp_progress'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_d = {},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}



local keymap_opts = { buffer = buffer }
-- Code navigation and shortcuts
vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)

-- lsp rename
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, keymap_opts)
-- lsp code action
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, keymap_opts)
-- RustLsp codeAction creates grouping if available and different interface if desired
-- vim.keymap.set("n", "ga", function() vim.cmd.RustLsp('codeAction') end, keymap_opts)

-- Hop setup
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('n', 'f', function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false }) end, {remap=true})
vim.keymap.set('n', 'F', function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false }) end, {remap=true})
vim.keymap.set('n', 't', function() hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false, hint_offset = -1 }) end, {remap=true})
vim.keymap.set('n', 'T', function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false, hint_offset = 1 }) end, {remap=true})

-- Telescope file browser setup
require("telescope").setup {
  extensions = {
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
}
vim.keymap.set("n", "<space>fB", ":Telescope file_browser<CR>")
require("telescope").load_extension "file_browser"




-- have a fixed column for the diagnostics to appear in
-- this removes the jitter/shift right when warnings/errors flow in
vim.wo.signcolumn = "yes"
-- show line numbers
vim.wo.number = true
-- colorscheme
vim.cmd.colorscheme "ayu-mirage"

