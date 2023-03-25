return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = function()
      require("plugins.lsp.diagnostic").setup()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspConfig", {}),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf
          require("plugins.lsp.format").on_attach(client, bufnr)
          require("plugins.lsp.keymap").on_attach(client, bufnr)
          require("plugins.lsp.autocmd").on_attach(client, bufnr)
        end,
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPre",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "jose-elias-alvarez/typescript.nvim" },
      { "folke/neodev.nvim", config = true },
      { "ray-x/lsp_signature.nvim" },
    },
    opts = {
      ensure_installed = {
        "cssls",
        "eslint",
        "gopls",
        "html",
        "intelephense",
        "jsonls",
        "lua_ls",
        "tsserver",
        "vimls",
        "yamlls",
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      local configs = {
        gopls = {
          on_attach = function(_, bufnr)
            require("lsp_signature").on_attach({
              hint_prefix = " ",
            }, bufnr)
          end,
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
            },
          },
        },
        lua_ls = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
              },
              completion = {
                callSnippet = "Replace",
                keywordSnippet = "Disable",
              },
              diagnostics = {
                enable = true,
                globals = {
                  "vim",
                },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        tsserver = {
          cmd = { "typescript-language-server", "--stdio" },
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
        },
        bufls = {
          cmd = { "bufls", "serve" },
          whitelist = "protocol",
        },
      }

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local options = { capabilities = capabilities }

      local lspconfig = require("lspconfig")
      require("mason-lspconfig").setup_handlers({
        function(server)
          local server_config = vim.tbl_deep_extend("force", options, configs[server] or {})
          if server == "tsserver" then
            require("typescript").setup({
              server = server_config,
            })
          else
            lspconfig[server].setup(server_config)
          end
        end,
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    opts = function()
      local null_ls = require("null-ls")
      return {
        sources = {
          null_ls.builtins.code_actions.eslint_d.with({
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
            },
          }),
          null_ls.builtins.diagnostics.golangci_lint,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.prettierd.with({
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "json",
            },
            extra_filetypes = { "php" },
            prefer_local = "node_modules/.bin",
          }),
          null_ls.builtins.formatting.stylua.with({
            condition = function(utils)
              local patterns = {
                "stylua.toml",
                ".stylua.toml",
              }
              return utils.root_has_file(patterns) or utils.has_file(patterns)
            end,
          }),
        },
      }
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {
        "eslint_d",
        "goimports",
        "prettierd",
        "stylua",
      },
    },
  },
}
