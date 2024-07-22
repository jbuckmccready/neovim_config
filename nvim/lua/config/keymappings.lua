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

		-- toggles from mini.basics
		{ mode = 'n', keys = '\\' },

		-- mini.surround
		{ mode = 'n', keys = 's' },
		{ mode = 'x', keys = 's' },

		-- mini.bracketed
		{ mode = 'n', keys = '[' },
		{ mode = 'x', keys = '[' },
		{ mode = 'n', keys = ']' },
		{ mode = 'x', keys = ']' },
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
		{ mode = 'x', keys = '<leader>s',  desc = 'Hop' },

		-- Direct Editing
		{ mode = 'n', keys = '<leader>e',  desc = 'Editing Actions' },
		{ mode = 'x', keys = '<leader>e',  desc = 'Editing Actions' },

		-- Git
		{ mode = 'n', keys = '<leader>g',  desc = 'Git' },
		{ mode = 'n', keys = '<leader>gn', postkeys = '<leader>g' },
		{ mode = 'n', keys = '<leader>gp', postkeys = '<leader>g' },
	},
})

vim.keymap.set({ 'n' }, '<leader>od', function() vim.cmd.RustLsp('openDocs') end, { desc = 'Open Rust Doc' })

local tele_builtin = require('telescope.builtin')
vim.keymap.set({ 'n' }, "<leader>ff", tele_builtin.find_files, { desc = "Find File" })
vim.keymap.set({ 'n' }, "<leader>fF", tele_builtin.oldfiles, { desc = "Previous Files" })
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
vim.keymap.set({ 'n' }, '<leader>f"', tele_builtin.registers, { desc = "Registers" })
vim.keymap.set({ 'n' }, "<leader>f'", tele_builtin.marks, { desc = "Marks" })
vim.keymap.set({ 'n' }, "<leader>fG", tele_builtin.git_branches, { desc = "Git Branches" })
vim.keymap.set({ 'n' }, "<leader>fc", tele_builtin.git_bcommits, { desc = "Buffer Git Commits" })
vim.keymap.set({ 'n' }, "<leader>fC", tele_builtin.git_commits, { desc = "Git Commits" })
vim.keymap.set({ 'n' }, "<leader>fe", tele_builtin.git_status, { desc = "Git Status" })
vim.keymap.set({ 'n' }, "<leader>fo", tele_builtin.git_stash, { desc = "Git Stash" })
vim.keymap.set({ 'n' }, "<leader>fl", tele_builtin.colorscheme, { desc = "Color Scheme" })
vim.keymap.set({ 'n' }, "<leader>fj", tele_builtin.jumplist, { desc = "Vim Jumplist" })
vim.keymap.set({ 'n' }, "<leader>fk", tele_builtin.keymaps, { desc = "Vim Keymaps" })
vim.keymap.set({ 'n' }, "<leader>fu", tele_builtin.resume, { desc = "Resume Telescope" })

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

-- Editing actions
vim.keymap.set({ "n" }, "<leader>er", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set({ "n", "x" }, "<leader>ea", require('actions-preview').code_actions, { desc = "Code Action" })
vim.keymap.set({ "n", "x" }, "<leader>es", tele_builtin.spell_suggest, { desc = "Spell Suggest" })

-- Misc. LSP
vim.keymap.set({ "n" }, "K", vim.lsp.buf.hover, { desc = "Hover Text" })

-- Hop setup
local hop = require('hop')
local directions = require('hop.hint').HintDirection

-- mimic the usual f, F, t, T mappings with hop variants
vim.keymap.set({ "n", "o", "x" }, "f", function() hop.hint_char1({ direction = directions.AFTER_CURSOR }) end,
	{ desc = "Hop 1Char After" })
vim.keymap.set({ "n", "o", "x" }, "F", function() hop.hint_char1({ direction = directions.BEFORE_CURSOR }) end,
	{ desc = "Hop 1Char Before" })
vim.keymap.set({ "n", "o", "x" }, "t",
	function() hop.hint_char1({ direction = directions.AFTER_CURSOR, hint_offset = -1 }) end,
	{ desc = "Hop 1Char After-1" })
vim.keymap.set({ "n", "o", "x" }, "T",
	function() hop.hint_char1({ direction = directions.BEFORE_CURSOR, hint_offset = 1 }) end,
	{ desc = "Hop 1Char Before-1" })

-- Hop leader group
-- global line hop
vim.keymap.set({ "n", "o", "x" }, "<leader>ss", function() hop.hint_lines({ multi_windows = true }) end,
	{ desc = "Hop Lines Global" })
vim.keymap.set({ "n", "o", "x" }, "<leader>sd", require('hop-treesitter').hint_nodes, { desc = "Hop Nodes" })
-- hop vertical
vim.keymap.set({ "n", "o", "x" }, "<leader>sv", function() hop.hint_vertical({ direction = directions.AFTER_CURSOR }) end,
	{ desc = "Hop Vertical After" })
vim.keymap.set({ "n", "o", "x" }, "<leader>sV",
	function() hop.hint_vertical({ direction = directions.BEFORE_CURSOR }) end, { desc = "Hop Vertical Before" })
-- hop to words
vim.keymap.set({ "n", "o", "x" }, "<leader>sw", function() hop.hint_words({ direction = directions.AFTER_CURSOR }) end,
	{ desc = "Hop Word After" })
vim.keymap.set({ "n", "o", "x" }, "<leader>sW", function() hop.hint_words({ direction = directions.BEFORE_CURSOR }) end,
	{ desc = "Hop Word Before" })
-- Neotree setup
vim.keymap.set({ "n" }, "<leader>t", "<cmd>Neotree toggle<CR>", { desc = "Toggle File Tree" })

-- Git setup
vim.keymap.set({ "n" }, "<leader>gg", "<cmd>Git<CR>", { desc = "Status", })
vim.keymap.set({ "n" }, "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Diff Current File", })
vim.keymap.set({ "n" }, "<leader>gs", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Hunk Diff", })
vim.keymap.set({ "n" }, "<leader>gn", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next Hunk", })
vim.keymap.set({ "n" }, "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous Hunk", })
vim.keymap.set({ "n" }, "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset Hunk", })
vim.keymap.set({ "n" }, "<leader>gl", "<cmd>Git log --oneline<CR>", { desc = "Commit Log", })
