## Hacked Neovim Setup

This is experimental/learning base setup for `neovim` with the goal of creating a starting point that seems "sensible" to me for code editing (specifically Rust to start).

Some goals:
- Cover all the basics: fast navigation, code completion/navigation, syntax highlighting, decent color scheme with semantic highlighting, etc.
- Don't compromise on any behavior I like about `vscode`, for example autocompletion behavior has been configured to match `vscode` default
- Avoid bloat/complexity/redundant configuration

### Contents

This git repository contains both `neovim` and `alacritty` configuration files in the `nvim` and `alacritty` directories respectively. E.g., on MacOS the path will be `~/.config/nvim` and `~/.config/alacritty`, on Windows it will be `~/AppData/Local/nvim` and `~/AppData/Roaming/alacritty` (or maybe different if installed differently).

Note also included is an optional color scheme for `alacritty` as toml file imported into `alacritty.toml`. File path must be changed if path to config is not `~/.config.alacritty`. Check the `alacritty.toml` file for more settings that were tweaked (e.g., to open maximized without window border).

`alacritty` was added just for convenience of getting a terminal running that will work.

### Things covered

- rust/go/lua via `mason`/`mason-lsp-config` and `rustaceanvim` (thin wrapper on lsp) for lsp, `treesitter` for syntax highlighting, and `cmp` for auto-completions
- git via `fugitive` (main git/diff operations) and `gitsigns` (indicators and blame line in editor)
- navigation via `telescope` (including on lsp symbols/info), `neotree`, `outline`, `hop`, and `mini.bracketed`
- status line via `mini.statusline`

### External tools notes

- you will need `alacritty` or some other decent terminal for real colors if on MacOS (default terminal is too limited), I switched to `alacritty` for speed
- nerd font for icons can be downloaded from [here](https://www.nerdfonts.com/font-downloads) (I am currently using ZedMono), then set it in terminal settings (if using `alacritty` see the `alacritty/alacritty.toml` file for example but this is in iTerm2 UI profile settings if using iTerm2 for example)
- color scheme is set to `catppuccin-mocha`, so far my favorite dark theme, I added some other popular color schemes as well
- rust analyzer for rust lsp (`rustup component add rust-analyzer` or can probably also install via `mason` plugin)
- `:LspInstall gopls` for go lsp, `TSInstall go` for go syntax highlighting
- `:LspInstall lua_ls` for lua lsp, `TSInstall lua` not required currently since it's in `ensure_installed` in `treesitter.lua`
- `cmake` and c compiler for building `telescope-fzf-native.nvim` (greatly speeds up searching in `neotree` and `telescope`)
- `git` for git things
- `fd` for faster file browsing
- `ripgrep` for telescope live grep


### Key mappings

I tried to keep all custom key mappings that are not associated with a plugin mode (anything that works in a standard mode inside a buffer) inside the `nvim/lua/config/keymappings.lua` file. There are other key mappings that are specific to plugin modes, e.g., telescope or autocompletion that are assigned during setup of the plugin. Additionally there are some key mappings added by `mini.basic` that can be found looking at `:h mini.basic`.

### Workflow

NOTE: `Space` is set as `<leader>` key, so wherever `<leader>` is shown it is `Space` unless you change the leader key (in `lua/config/lazy.lua`). `mini.clue` plugin is used to help discover key mappings (a popup is shown in UI after first key map is pressed to show following key maps available).

I try to use default key mappings as much as possible (when they are sensible) and anything not mentioned here is likely utilizing default key mappings, I use `<C-w` for window controls, `zz` for center on cursor, etc. `mini.basics` mappings are added for some additional useful basics, e.g., `<C-h`, `<C-j>`, `<C-k>`, `<C-l>` can be used to jump between windows, `\` followed by `s` to toggle spelling, `b` toggle background, `h` toggle highlight, etc.

Use `neotree` (`<leader>t`) to toggle open file tree browser, `?` for help, fast search via `/` or `#` inside of it, can be used to change the neovim working directory (`.`) for telescope file finding.

Use `telescope` (`<leader>f` to access group with commands) to do file search (e.g, `<leader>ff`, equivalent to `<Cmd>p` in `vscode`), buffer search, live grep search using `ripgrep`, and more. One very useful telescope search is to search help/documentation, telescope is also used for LSP navigation/browser, e.g., `<leader>fr` for find all references for symbol under cursor, `<leader>fd` for all lsp diagnostics (warnings/errors), etc.

Use `hop` (remapped `f`, `F`, `t`, `T` for single char jump and `<leader>s` for more hop commands) for easier buffer navigation.

Use tabs with tuned key mappings: `<leader>n` for new tab, `<leader>c` close tab, `<leader>{number}` to jump to tab number, `<leader>h` to cycle left one tab, `<leader>l` to cycle right one tab.

Use jump out of terminal mode via usual `<C-w>h`, `<C-w>j`, `<C-w>k`, `<C-w>h` without having to return to normal mode first (makes having split buffer for terminal more convenient). 

Use `fugitive` and `Gitsigns` for git operations and viewing diffs (`<leader>g` to open command group, `<leader>gg` will open main summary/status, `<leader>gd` will diff current file unstaged changes, and more). `:Git` can be used to run git CLI as expected (e.g., `:Git commit`, `:Git push`, etc. using vim buffers where useful). Additionally you can use `telescope` to interact with git status, commits, and stash.

Use `outline` (`<leader>o`) for code/symbols outline (similar to `neotree` but for symbols in file).

Some additional notes:
- Cycle auto-completions via `C-n` (or `<down>`) and `C-p` (or `<up>`), `tab` or `<CR>` to complete.
- Editing actions (symbol rename, lsp code action, spell suggest, etc.): `<leader>e`
- Use toggle `spell` to turn on spell check, `<leader>e` with cursor over word for spell suggest
- Hover (for peeking docs on symbol): `K` (press again to toggle into it to jump to symbols from `rust-analyzer`)
- `<f1>` to open Rust docs link for symbol under cursor
- `:RustLsp expandMacro` to recursively expand Rust macro under cursor (no key mapping since it's not frequent)
