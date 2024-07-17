## Hacked Neovim Setup

This is experimental/learning setup for neovim just hacked together.

### Things covered

- rust/go/lua via `mason` lsp-config and `rustaceanvim` (thin wrapper on lsp) for lsp, `treesitter` for syntax highlighting, and `cmp` for auto-completions
- git via `neogit` (git browsing/operating) and `git-blame` (quick commit info on line in buffer)
- navigation via `telescope`, `neotree`, `hop`, and lsp bindings
- status line via `lualine`

### External/manual opt-in notes

- rust analyzer for rust lsp (`rustup component add rust-analyzer` or can probably install via `mason` plugin)
- `:LspInstall gopls` for go lsp, `TSInstall go` for go syntax highlighting
- `:LspInstall lua_ls` for lua lsp, `TSInstall lua` not required currently since it's in `ensure_installed` in `treesitter.lua`
- `cmake` and c compiler for building `telescope-fzf-native.nvim` (greatly speeds up searching in `neotree` and `telescope`)
- `git` for git things
- `fd` for faster file browsing
- `ripgrep` for telescope live grep


### Workflow

NOTE: `space` is set as `<leader>` key and is referenced as such.

Use `neotree` (`space-t`) to get file browswer, fast search via `/` or `#` inside of it, can be used to change working directory for telescope.

Use `telescope` (`space-ff`, `space-fb`, `space-fg`) to do file search, buffer search, and grep search.

Use `hop` (remapped `f`, `F`, `t`, `T` for single char on line jump and `space-s`, `space-S` for word jump) for easier buffer navigation.

Use tabs with keymaps: `space-n` for new tab, `space-{number}` to jump to tab number, `space-h` to move to left tab, `space-l` to move to right tab.

Use jump out of terminal mode via usual `<C-w>h`, `<C-w>j`, `<C-w>k`, `<C-w>h` without having to return to normal mode first (makes having split buffer for terminal more convenient). 

Use `neogit` for git operations and viewing diffs, `space-g` (opens new tab).

Use lsp navigation and code actions:
- Cycle auto-completions via `C-n` and `C-p`
- Symbol searches: `space-fs` for buffer, `space-fS` for workspace
- All lsp diagnostics (warnings/errors): `space-fd`
- All references: `gr`
- Code actions: `ga`
- Hover (for peeking docs on symbol): `K`
- Go to implementation: `gD`
- Rename symbol: `F2`
