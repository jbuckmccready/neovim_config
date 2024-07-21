## Hacked Neovim Setup

This is experimental/learning base setup for `neovim` with the goal of creating a starting point that seems "sensible" to me for code editing (specifically Rust to start).

Some goals:
- Cover all the basics: fast navigation, code completion/navigation, syntax highlighting, decent color scheme with semantic highlighting, etc.
- Don't compromise on any behavior I like about `vscode`, for example autocompletion behavior has been configured to match `vscode` default
- Avoid bloat/complexity/redundant configuration

### Contents

This git repository contains both `neovim` and `alacritty` configuration files in the `nvim` and `alacritty` directories respectively. E.g., on macOS the path will be `~/.config/nvim` and `~/.config/alacritty`, on Windows it will be `~/AppData/Local/nvim` and `~/AppData/Roaming/alacritty` (or maybe different if installed differently).

`alacritty` was added just for convenience of getting a terminal running that will work.

### Things covered

- rust/go/lua via `mason`/`mason-lsp-config` and `rustaceanvim` (thin wrapper on lsp) for lsp, `treesitter` for syntax highlighting, and `cmp` for auto-completions
- git via `fugitive` (main git/diff operations) and `gitsigns` (indicators and blame line in editor)
- navigation via `telescope`, `neotree`, `hop`, and lsp bindings
- status line via `lualine`

### External tools notes

- you will need `alacritty` or some other decent terminal for real colors if on macOS (default terminal is too limited), I switched to `alacritty` for speed
- nerd font for icons can be downloaded from [here](https://www.nerdfonts.com/font-downloads) (I am currently using ZedMono), then set it in terminal settings (if using `alacritty` see the `alacritty/alacritty.toml` file for example but this is in iTerm2 UI profile settings if using iTerm2 for example)
- theme is set to `catppuccin-mocha`, so far my favorite dark theme
- rust analyzer for rust lsp (`rustup component add rust-analyzer` or can probably also install via `mason` plugin)
- `:LspInstall gopls` for go lsp, `TSInstall go` for go syntax highlighting
- `:LspInstall lua_ls` for lua lsp, `TSInstall lua` not required currently since it's in `ensure_installed` in `treesitter.lua`
- `cmake` and c compiler for building `telescope-fzf-native.nvim` (greatly speeds up searching in `neotree` and `telescope`)
- `git` for git things
- `fd` for faster file browsing
- `ripgrep` for telescope live grep

### Workflow

NOTE: `Space` is set as `<leader>` key, so wherever `<leader>` is shown it is `Space` unless you change the leader key (in `lua/config/lazy.lua`). `which-key` plugin is used to help discover key mappings (a popup is shown in UI after first key map is pressed to show following key maps available).

I try to use default key mappings as much as possible (when they are sensible) and anything not mentioned here is likely utilizing default key mappings, I use `<C-w` for window controls, `zz` for center on cursor, etc.

Use `neotree` (`<leader>-t`) to toggle open file tree browser, `?` for help, fast search via `/` or `#` inside of it, can be used to change working directory (`.`) for telescope.

Use `telescope` (`<leader>-f` to access group with commands) to do file search (e.g, `<leader>ff`, equivalent to `<Cmd>p` in `vscode`), buffer search, live grep search using `ripgrep`, and more. One very useful telescope search is to search help/documentation, telescope is also used for LSP navigation/browser, e.g., `<leader>fr` for find all references for symbol under cursor, `<leader>-fd` for all lsp diagnostics (warnings/errors), etc.

Use `hop` (remapped `f`, `F`, `t`, `T` for single char jump and `<leader>-s` and `<leader>-S` for word jump) for easier buffer navigation.

Use tabs with tuned key mappings: `<leader>-n` for new tab, `<leader>-{number}` to jump to tab number, `<leader>-h` to cycle left one tab, `<leader>-l` to cycle right one tab.

Use jump out of terminal mode via usual `<C-w>h`, `<C-w>j`, `<C-w>k`, `<C-w>h` without having to return to normal mode first (makes having split buffer for terminal more convenient). 

Use `fugitive` and `Gitsigns` (`<leader>-g` to access group with commands `g?` for help) for git operations and viewing diffs (e.g., `<leader>-gg` will open main summary/status, `<leader>gd` will diff current file unstaged changes). `:Git` can be used to run git CLI as expected (e.g., `:Git commit`, using vim buffers where useful).

Some additional notes:
- Cycle auto-completions via `C-n` and `C-p`, `tab` or `<CR>` to complete.
- Code actions: `ga`
- Hover (for peeking docs on symbol): `K`
- Rename symbol under cursor: `F2`
