-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "LazyVimStarted",
  callback = function()
    local notes_dir = "/home/tudor/cave/littlebrain"
    local current_dir = vim.fn.getcwd()
    if vim.fn.argc() == 0 and current_dir == notes_dir then
      local ok, persistence = pcall(require, "persistence")
      if ok then
        persistence.load()
      end
    end
  end,
})
