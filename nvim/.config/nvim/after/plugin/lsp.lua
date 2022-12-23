local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

local telescope = require("me.telescope")
local keymap = require("me.keymap")
local inoremap = keymap.inoremap
local nnoremap = keymap.nnoremap

vim.diagnostic.config({
  virtual_text = false,
})

local diagnostic_sign = { Error = "", Warn = "", Hint = "", Info = "" }
for key, value in pairs(diagnostic_sign) do
  local name = string.format("DiagnosticSign%s", key)
  vim.fn.sign_define(name, { text = value, texthl = name })
end

nnoremap("<space>e", vim.diagnostic.open_float)
nnoremap("[d", vim.diagnostic.goto_prev)
nnoremap("]d", vim.diagnostic.goto_next)
nnoremap("<space>q", vim.diagnostic.setloclist)

local function on_attach(client, bufnr)
  inoremap("<C-k>", vim.lsp.buf.signature_help)
  nnoremap("gd", telescope.lsp_definitions)
  nnoremap("gD", vim.lsp.buf.declaration)
  nnoremap("gT", vim.lsp.buf.type_definition)
  nnoremap("K", vim.lsp.buf.hover)
  nnoremap("<space>gI", vim.lsp.buf.implementation)
  nnoremap("<space>cr", vim.lsp.buf.rename)
  nnoremap("<space>ca", vim.lsp.buf.code_action)
  nnoremap("gr", telescope.lsp_references)
  nnoremap("gI", telescope.lsp_implementations)

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

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local function config(opts)
  return vim.tbl_deep_extend("force", {
    capabilities = capabilities,
    on_attach = on_attach,
  }, opts or {})
end

local opts = {
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
}

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

require("neodev").setup({})
require("mason-lspconfig").setup_handlers({
  function(server)
    if server == "tsserver" then
      require("typescript").setup({
        server = config(opts[server]),
      })
    else
      lspconfig[server].setup(config(opts[server]))
    end
  end,
})
