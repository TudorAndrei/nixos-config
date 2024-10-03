vim.g.mapleader = ","
vim.g.maplocalleader = ","
local opt = vim.opt
opt.scl = "yes:2"
opt.tabstop = 4
opt.softtabstop = 4
opt.swapfile = false
vim.filetype.add({
  extension = {
    jinja = "jinja",
    jinja2 = "jinja",
    j2 = "jinja",
  },
})
