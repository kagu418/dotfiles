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
}
