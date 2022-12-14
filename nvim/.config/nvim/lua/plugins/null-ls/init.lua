local M = {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = {
    { "jay-babu/mason-null-ls.nvim" },
  },
  event = { "BufReadPre" },
}

local function config()
  local null_ls = require("null-ls")

  null_ls.setup({
    on_attach = require("plugins.null-ls.formatting").setup,
  })

  local code_actions = null_ls.builtins.code_actions
  local diagnostics = null_ls.builtins.diagnostics
  local formatting = null_ls.builtins.formatting
  local register = null_ls.register

  require("mason-null-ls").setup({
    ensure_installed = {
      "eslintd",
      "goimports",
      "prettierd",
      "stylua",
    },
  })

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
end

M.config = config

return M
