local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end
map("n", "<c-h>", "<cmd>lua require('tmux').move_left()<cr>")
map("n", "<c-j>", "<cmd>lua require('tmux').move_down()<cr>")
map("n", "<c-k>", "<cmd>lua require('tmux').move_up()<cr>")
map("n", "<c-l>", "<cmd>lua require('tmux').move_right()<cr>")
map("n", "<c-n>", "<cmd>Neotree toggle<cr>")
