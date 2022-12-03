local ok, null_ls = pcall(require, "null-ls")
if not ok then
  return
end

require("mason-null-ls").setup({
  ensure_installed = {
    "eslintd",
    "goimports",
    "prettierd",
    "stylua",
  },
})

local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local register = null_ls.register

require("mason-null-ls").setup_handlers({
  eslint_d = function()
    register(code_actions.eslint_d.with({
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
    }))
  end,
  golangci_lint = function()
    register(diagnostics.golangci_lint)
  end,
  goimports = function()
    register(formatting.goimports)
  end,
  prettierd = function()
    register(formatting.prettierd.with({
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
      },
      extra_filetypes = { "php" },
      prefer_local = "node_modules/.bin",
    }))
  end,
  stylua = function()
    register(formatting.stylua.with({
      condition = function(utils)
        local patterns = {
          "stylua.toml",
          ".stylua.toml",
        }
        return utils.root_has_file(patterns) or utils.has_file(patterns)
      end,
    }))
  end,
})

local lsp_formatting = vim.api.nvim_create_augroup("LspFormatting", {})
local function on_attach(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = lsp_formatting, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lsp_formatting,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
          filter = function()
            return client.name == "null-ls"
          end,
        })
      end,
    })
  end
end

null_ls.setup({
  on_attach = on_attach,
})
