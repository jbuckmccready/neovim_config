return {
  'nvim-treesitter/nvim-treesitter',
  version = '*',
  config = function()
    require("nvim-treesitter.configs").setup {
      highlight = {
        enable = true,
      },
      ensure_installed = {
        "vimdoc",
        "luadoc",
        "vim",
        "lua",
        "markdown"
      }
    }
  end,
}

