local is_nixos = vim.fn.getenv("NIX_PROFILES") ~= ""

return {
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },
  { "catppuccin/nvim", enabled = false },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "linux-cultist/venv-selector.nvim", enabled = false },
  {
    "mason-org/mason.nvim",
    enabled = false,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    enabled = false,
  },
  {
    "ibhagwan/fzf-lua",
    enabled = false,
  },
  -- { "folke/trouble.nvim", enabled = false },
}
