return {
  { "Mofiqul/dracula.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
      defaults = {
        automd = false,
      },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "hjson",
        "gleam",
        "c",
        "rust",
        "lua",
        "typescript",
        "python",
        "javascript",
        "bash",
        "html",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "vim",
        "yaml",
        "json",
        "toml",
      },
      highlight = {
        enable = true,
      },
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
      },
      indent = {
        enable = true,
      },
      refactor = {
        highlight_definitions = { enable = true },
      },
      autotag = {
        enable = true,
      },
    },
  },
  { "nathom/tmux.nvim" },
}
