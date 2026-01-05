return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/cave/littlebrain/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/cave/littlebrain/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "littlebrain",
        path = "~/cave/littlebrain",
      },
    },
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      template = "templates/daily.md",
    },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    new_notes_location = "current_dir",
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        suffix = tostring(os.time())
      end
      return suffix
    end,
    ui = { enable = false },
    legacy_commands = false,
  },
}
