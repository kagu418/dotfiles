local M = {}

local function setup()
  vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
  })

  local nnoremap = require("core.keymap").nnoremap
  nnoremap("<space>e", vim.diagnostic.open_float)
  nnoremap("[d", vim.diagnostic.goto_prev)
  nnoremap("]d", vim.diagnostic.goto_next)
  nnoremap("[e", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end)
  nnoremap("]e", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end)
  nnoremap("[w", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
  end)
  nnoremap("]w", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
  end)
  nnoremap("<space>q", vim.diagnostic.setloclist)

  local sign = { Error = "", Warn = "", Hint = "", Info = "" }
  for key, value in pairs(sign) do
    local name = string.format("DiagnosticSign%s", key)
    vim.fn.sign_define(name, { text = value, texthl = name })
  end
end

M.setup = setup

return M
