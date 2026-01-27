return {
  {
    "direnv/direnv.vim",
  },
  {
    "NotAShelf/direnv.nvim",
    config = function()
      require("direnv").setup({
        bin = "direnv",
        autoload_direnv = true,
      })
    end,
  },
}
