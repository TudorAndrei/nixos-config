return {
  { "Mofiqul/dracula.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
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
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = function()
      local is_nixos = vim.fn.getenv("NIX_PROFILES") ~= ""
      
      local mason_opts = {
        ensure_installed = {},
        automatic_installation = not is_nixos,
      }
      
      if not is_nixos then
        mason_opts.ensure_installed = {
          "basedpyright",
          "hadolint",
          "json-lsp",
          "lua-language-server",
          "docker-compose-language-service",
          "dockerfile-language-server",
          "djlint",
          "biome",
          "rustywind",
          "jinja-lsp",
          "marksman",
          "stylua",
          "selene",
          "taplo",
          "rust-analyzer",
          "tailwindcss-language-server",
        }
      end
      
      return mason_opts
    end,
  },
  { "nathom/tmux.nvim" },
}
