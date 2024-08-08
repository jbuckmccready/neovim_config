return {
	'hrsh7th/nvim-cmp',
	dependencies = {
		-- cmp LSP completion
		"hrsh7th/cmp-nvim-lsp",
		-- cmp luasnip completion
		"saadparwaiz1/cmp_luasnip",
		-- cmp Path completion
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"zjp-CN/nvim-cmp-lsp-rs",
	},
	config = function()
		local cmp = require('cmp')
		local cmp_compare = require("cmp").config.compare
		-- using comparators from this plugin to improve rust autocomplete ordering
		local cmp_rs_compare = require("cmp_lsp_rs").comparators

		cmp.setup({
			preselect = cmp.PreselectMode.None,
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end
			},
			mapping = {
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
				["<down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
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

			sorting = {
				comparators = {
					cmp_compare.exact,
					cmp_compare.score,
					cmp_rs_compare.inscope_inherent_import,
					cmp_rs_compare.sort_by_label_but_underscore_last,
				},
			},

			-- Installed sources
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip", keyword_length = 2 },
				{ name = "path" },
				{ name = "buffer",  keyword_length = 3, max_item_count = 10 },
			},
			-- Border window for visual clarity
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			formatting = {
				-- Formatting function to limit width and add icon for source
				format = function(entry, vim_item)
					local ELLIPSIS_CHAR = '…'
					local MAX_LABEL_WIDTH = 100
					local MIN_LABEL_WIDTH = 20
					local label = vim_item.abbr
					local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
					if truncated_label ~= label then
						vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
					elseif string.len(label) < MIN_LABEL_WIDTH then
						local padding = string.rep(' ',
							MIN_LABEL_WIDTH - string.len(label))
						vim_item.abbr = label .. padding
					end

					local menu_icon = {
						nvim_lsp = 'λ',
						luasnip = '⋗',
						buffer = 'Ω',
						path = '🖫',
					}

					vim_item.menu = menu_icon[entry.source.name]
					return vim_item
				end,
			},
		})
	end,
}
