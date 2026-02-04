return {
  {
    "Mofiqul/dracula.nvim",
    opts = {
      overrides = function(colors)
        return {
          -- Fix diff colors for better readability in git diff views
          DiffAdd = { fg = colors.green, bg = "#1a2b1a" },
          DiffDelete = { fg = colors.red, bg = "#2b1a1a" },
          DiffChange = { fg = colors.orange, bg = "#2b251a" },
          DiffText = { fg = colors.fg, bg = "#3d2d1a", bold = true },
        }
      end,
    },
  },
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
