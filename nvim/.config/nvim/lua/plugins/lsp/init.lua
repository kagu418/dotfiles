return {
  { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
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
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
      { "mason.nvim" },
      { "jose-elias-alvarez/typescript.nvim" },
      { "simrat39/rust-tools.nvim" },
      { "folke/neodev.nvim", opts = {} },
      { "b0o/SchemaStore.nvim", version = false },
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
        require("plugins.lsp.keymaps").on_attach(client, bufnr)
      end)

      lsp_zero.set_sign_icons({
        error = "",
        warn = "",
        hint = "",
        info = "",
      })

      lsp_zero.format_on_save({
        servers = {
          gopls = { "go" },
          rust_analyzer = { "rust" },
          ["null-ls"] = {
            "lua",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "json",
            "html",
            "php",
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "cssls",
          "dockerls",
          "docker_compose_language_service",
          "eslint",
          "golangci_lint_ls",
          "gopls",
          "html",
          "intelephense",
          "jsonls",
          "lua_ls",
          "rust_analyzer",
          "tsserver",
          "vimls",
          "yamlls",
        },
        handlers = {
          lua_ls = function()
            require("lspconfig").lua_ls.setup(lsp_zero.nvim_lua_ls({
              on_attach = function(client)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
              end,
              settings = {
                Lua = {
                  completion = {
                    callSnippet = "Replace",
                    keywordSnippet = "Disable",
                  },
                },
              },
            }))
          end,
          gopls = function()
            require("lspconfig").gopls.setup({
              settings = {
                gopls = {
                  codelenses = {
                    gc_details = false,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                  },
                  hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                  },
                  analyses = {
                    fieldalignment = true,
                    nilness = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true,
                  },
                  usePlaceholders = true,
                  completeUnimported = true,
                  staticcheck = true,
                  semanticTokens = true,
                },
              },
            })
          end,
          golangci_lint_ls = function()
            require("lspconfig").golangci_lint_ls.setup({
              filetypes = { "go", "gomod" },
            })
          end,
          jsonls = function()
            require("lspconfig").jsonls.setup({
              settings = {
                json = {
                  format = {
                    enable = true,
                  },
                  validate = {
                    enable = true,
                  },
                  schemas = require("schemastore").json.schemas(),
                },
              },
            })
          end,
          yamlls = function()
            require("lspconfig").yamlls.setup({
              settings = {
                redhat = {
                  telemetry = {
                    enabled = false,
                  },
                },
                yaml = {
                  keyOrdering = false,
                  format = {
                    enable = true,
                  },
                  validate = {
                    enable = true,
                  },
                  schemaStore = {
                    enable = false,
                    url = "",
                  },
                  schemas = require("schemastore").yaml.schemas(),
                },
              },
            })
          end,
          tsserver = function()
            require("typescript").setup({
              server = {
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
            })
          end,
          rust_analyzer = function()
            require("rust-tools").setup({
              server = {
                ["rust-analyzer"] = {
                  cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    runBuildScripts = true,
                  },
                  checkOnSave = {
                    allFeatures = true,
                    command = "clippy",
                    extraArgs = { "--no-deps" },
                  },
                },
                on_attach = function(_, bufnr)
                  vim.keymap.set(
                    "n",
                    "<space>ca",
                    require("rust-tools").hover_actions.hover_actions,
                    { buffer = bufnr }
                  )
                end,
              },
            })
          end,
        },
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = {
      { "jay-babu/mason-null-ls.nvim" },
    },
    config = function()
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.code_actions.eslint_d.with({
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
            },
          }),
          require("null-ls").builtins.formatting.prettierd.with({
            filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "json",
              "html",
            },
            extra_filetypes = { "php" },
            prefer_local = "node_modules/.bin",
          }),
          require("null-ls").builtins.formatting.stylua.with({
            condition = function(utils)
              local patterns = {
                "stylua.toml",
                ".stylua.toml",
              }
              return utils.root_has_file(patterns) or utils.has_file(patterns)
            end,
          }),
          require("null-ls").builtins.diagnostics.hadolint,
          require("typescript.extensions.null-ls.code-actions"),
        },
      })
      require("mason-null-ls").setup({
        ensure_installed = nil,
        automatic_installation = true,
      })
    end,
  },
}
