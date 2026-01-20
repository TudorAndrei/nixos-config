local pypath = vim.g.current_python_path
local nixos_dir = "~/nixos-config/"

vim.diagnostic.config({
  signs = {
    Text = " ",
    Num = " ",
    Error = "x",
    Warn = "!",
    Hint = "i",
    Info = ">",
  },
})

return {
  { "lepture/vim-jinja" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        ["*"] = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = false,
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        nixd = {
          settings = {
            nixd = {
              formatting = {
                command = { "alejandra" },
              },
              nixpkgs = {
                expr = string.format("import (builtins.getFlake %s).inputs.nixpkgs {}", nixos_dir),
              },
              options = {
                nixos = {
                  expr = string.format("(builtins.getFlake %s).nixosConfiguration.sparta.options", nixos_dir),
                },
                home_manager = {
                  expr = string.format(
                    "(builtins.getFlake %s).homeConfigurations.%s.options",
                    nixos_dir,
                    os.getenv("USER")
                  ),
                },
              },
            },
          },
        },
        jinja_lsp = {},
        clangd = {},
        docker_compose_language_service = {},
        dockerls = {},
        jsonls = {},
        rust_analyzer = {},
        tailwindcss = {
          filetypes_include = { "jinja" },
        },
        taplo = {},
        tsserver = {},
        yamlls = {},
        biome = {},
        ruff = {
          capabilities = {
            hoverProvider = false,
          },
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true,
              typeCheckingMode = "standard",
            },
            python = {
              -- pythonPath = pypath,
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
              },
            },
          },
          flags = {
            debounce_text_changes = 150,
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "biome" },
        html = { "djlint", "rustywind" },
        jinja = { "djlint", "rustywind" },
        css = { "prettierd" },
        python = { "ruff" },
        lua = { "stylua" },
        yaml = { "yamlfmt" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene" },
        css = { "stylelint" },
        markdown = { "markdownlint" },
        yaml = { "yamllint" },
        dockerfile = { "hadolint" },
      },
      linters = {
        selene = {
          condition = function(ctx)
            return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
  -- TODO: check the default
  {
    "danymat/neogen",
    keys = {
      { "<leader>nf", "<cmd>:lua require('neogen').generate()<CR>", desc = "Generate docstrings" },
    },
    opts = {
      enabled = true,
      snippet_engine = "luasnip",
      languages = {
        python = {
          template = {
            annotation_convention = "google_docstrings",
          },
        },
      },
    },
  },
  {
    "nvim-neotest/neotest-python",
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          runner = "pytest",
          python = ".venv/bin/python",
        },
      },
    },
  },
}
