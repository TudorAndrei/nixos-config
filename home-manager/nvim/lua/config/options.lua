vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.lazyvim_picker = "snacks"

local opt = vim.opt
opt.signcolumn = "no"
opt.tabstop = 4
opt.softtabstop = 4
opt.swapfile = false

vim.schedule(function()
  opt.clipboard = ""
end)

vim.filetype.add({
  extension = {
    jinja = "jinja",
    jinja2 = "jinja",
    j2 = "jinja",
  },
})
