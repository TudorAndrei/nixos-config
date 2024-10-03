return {
  "b0o/blender.nvim",
  keys = {
    { "<leader>Po", "<cmd>Blender<cr>", desc = "Open Blender UI" },
    { "<leader>Pl", "<cmd>BlenderLaunch<cr>", desc = "Launch a Blender Profile" },
    { "<leader>Pm", "<cmd>BlenderManage<cr>", desc = "Manage a running  Blender task" },
    { "<leader>Pr", "<cmd>BlenderReload<cr>", desc = "Reload a blender add-on" },
    { "<leader>Pw", "<cmd>BlenderWatch<cr>", desc = "Watch for changes and reload the add-on" },
    { "<leader>Pu", "<cmd>BlenderUnwatch<cr>", desc = "Stop watching for changes" },
  },
  config = function()
    require("blender").setup({
      profiles = { --                 Profile[]?       list of blender profiles
        {
          name = "Blender 3.6.12", --        string           profile name, must be unique
          cmd = "/home/tudor/.blender_builds/stable/blender-3.6.12-lts.626a6b1c6799/blender", --         string|string[]  command to run Blender
        },
        {
          name = "Blender 4.1.1", --        string           profile name, must be unique
          cmd = "/home/tudor/.blender_builds/stable/blender-4.1.1-stable.e1743a0317bc/blender", --         string|string[]  command to run Blender
        },
        {
          name = "Flatpak Blender 4.1.1", --        string           profile name, must be unique
          cmd = "/var/lib/flatpak/exports/bin/org.blender.Blender", --         string|string[]  command to run Blender
        },
      },
      dap = { --                      DapConfig?       DAP configuration
        enabled = true, --            boolean?         whether to enable DAP (can be overridden per profile)
      },
      notify = { --                   NotifyConfig?    notification configuration
        enabled = true, --            boolean?         whether to enable notifications
        verbosity = "INFO", --        'TRACE'|'DEBUG'|'INFO'|'WARN'|'ERROR'|'OFF'|vim.log.level?  log level for notifications
      },
      watch = { --                    WatchConfig?     file watcher configuration
        enabled = true, --            boolean?         whether to watch the add-on directory for changes (can be overridden per profile)
      },
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "grapp-dev/nui-components.nvim",
    "mfussenegger/nvim-dap", -- Optional, for debugging with DAP
    "LiadOz/nvim-dap-repl-highlights", -- Optional, for syntax highlighting in the DAP REPL
  },
}
