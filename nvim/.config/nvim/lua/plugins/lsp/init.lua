local M = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp" },
    { "jose-elias-alvarez/typescript.nvim" },
    { "folke/neodev.nvim", config = true },
    { "ray-x/lsp_signature.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
  },
}

local function on_attach(client, bufnr)
  require("plugins.lsp.mappings").setup()

  local lsp_diagnostic_open = vim.api.nvim_create_augroup("LspDiagnosticOpen", {})
  vim.api.nvim_clear_autocmds({
    group = lsp_diagnostic_open,
    buffer = bufnr,
  })
  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    group = lsp_diagnostic_open,
    buffer = bufnr,
    callback = function()
      for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(window).relative ~= "" then
          return
        end
      end
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = function(_, i, total)
          return total <= 1 and " " or string.format(" %d. ", i)
        end,
        scope = "cursor",
      }
      vim.diagnostic.open_float(opts)
    end,
  })

  if client.server_capabilities.documentHighlightProvider then
    local lsp_document_highlight = vim.api.nvim_create_augroup("LspDocumentHighlight", {})
    vim.api.nvim_clear_autocmds({
      group = lsp_document_highlight,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = lsp_document_highlight,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = lsp_document_highlight,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

local function config()
  require("plugins.lsp.diagnostic").setup()

  local configs = {
    gopls = {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
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
    sumneko_lua = {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
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
        on_attach(client)
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
      whitelist = "proto",
    },
  }

  local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
  local options = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  local lspconfig = require("lspconfig")
  require("mason-lspconfig").setup({
    ensure_installed = {
      "cssls",
      "eslint",
      "gopls",
      "html",
      "intelephense",
      "jsonls",
      "sumneko_lua",
      "tsserver",
      "vimls",
      "yamlls",
    },
  })
  require("mason-lspconfig").setup_handlers({
    function(server)
      local server_config = vim.tbl_deep_extend("force", {}, options, configs[server] or {})

      if server == "tsserver" then
        require("typescript").setup({
          server = server_config,
        })
      else
        lspconfig[server].setup(server_config)
      end
    end,
  })
end

M.config = config

return M
