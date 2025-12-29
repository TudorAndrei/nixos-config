local function mysplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

local copilot = function()
  local icon = LazyVim.config.icons.kinds.Copilot
  local status = require("copilot.api").status.data
  return icon .. (status.message or "")
end

local cond_copilot = function()
  if not package.loaded["copilot"] then
    return
  end
  local ok, clients = pcall(LazyVim.lsp.get_clients, { name = "copilot", bufnr = 0 })
  if not ok then
    return false
  end
  return ok and #clients > 0
end
local color_copilot = function()
  local colors = {
    [""] = LazyVim.ui.fg("Special"),
    ["Normal"] = LazyVim.ui.fg("Special"),
    ["Warning"] = LazyVim.ui.fg("DiagnosticError"),
    ["InProgress"] = LazyVim.ui.fg("DiagnosticWarn"),
  }
  if not package.loaded["copilot"] then
    return
  end
  local status = require("copilot.api").status.data
  return colors[status.status] or colors[""]
end
local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local function conda_env()
  local conda_pref = os.getenv("CONDA_PREFIX")
  if string.find(conda_pref, "envs") then
    local env = mysplit(conda_pref, "/")
    return (string.format("🐍%s", env[#env]))
  else
    return ""
  end
end

local function venv_env()
  local venv = os.getenv("VIRTUAL_ENV")
  if venv then
    local env = mysplit(venv, "/")
    return (string.format("(%s)", env[#env]))
  else
    return ""
  end
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = false,
}

local function ollama_status()
  local status = require("ollama").status()
  if status == "IDLE" then
    return "󱙺" -- nf-md-robot-outline
  elseif status == "WORKING" then
    return "󰚩" -- nf-md-robot
  end
end
local function getWords()
  if vim.bo.filetype == "md" or vim.bo.filetype == "txt" or vim.bo.filetype == "rmd" then
    if vim.fn.wordcount().visual_words == 1 then
      return tostring(vim.fn.wordcount().visual_words) .. " word"
    elseif not (vim.fn.wordcount().visual_words == nil) then
      return tostring(vim.fn.wordcount().visual_words) .. " words"
    else
      return tostring(vim.fn.wordcount().words) .. " words"
    end
  else
    return ""
  end
end

local diff = {
  "diff",
  colored = false,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width,
}

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local location = {
  "location",
  padding = 0,
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 2, {})
      return {
        options = {
          theme = "dracula",
          icons_enabled = true,
          component_separators = {},
          section_separators = {},
          disabled_filetypes = { "dashboard", "TelescopePrompt" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { branch },
          lualine_c = { "filename", diagnostics },
          lualine_x = { { copilot, cond_copilot, color_copilot }, { ollama_status }, diff, "encoding", { getWords } },
          lualine_y = { filetype, conda_env, venv_env },
          lualine_z = { location },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { location },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "trouble", "fzf", "mason", "nvim-tree", "lazy", "symbols-outline" },
      }
    end,
  },
  {
    "j-hui/fidget.nvim",
  },
  {
    "folke/lsp-colors.nvim",
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        show_buffer_icons = false, -- disable filetype icons for buffers
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = { "|" },
        offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
        show_tab_indicators = true,
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    opts = {
      enable_check_bracket_line = false,
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" })
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      scratch = { enabled = false },
      terminal = { enabled = false },
      scroll = { enabled = false },
      indent = { enabled = true },
    },
  },
}
