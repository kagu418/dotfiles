local M = {}

local function goto_prev(opts)
  vim.diagnostic.goto_prev(opts)
  vim.api.nvim_feedkeys("zz", "n", false)
end

local function goto_next(opts)
  vim.diagnostic.goto_next(opts)
  vim.api.nvim_feedkeys("zz", "n", false)
end

local function config()
  vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
  })
end

local function keymap()
  local nnoremap = require("core.keymap").nnoremap
  nnoremap("<space>e", vim.diagnostic.open_float)
  nnoremap("[d", goto_prev)
  nnoremap("]d", goto_next)
  -- stylua: ignore
  nnoremap("[e", function() goto_prev({ severity = vim.diagnostic.severity.ERROR }) end)
  -- stylua: ignore
  nnoremap("]e", function() goto_next({ severity = vim.diagnostic.severity.ERROR }) end)
  -- stylua: ignore
  nnoremap("[w", function() goto_prev({ severity = vim.diagnostic.severity.WARN }) end)
  -- stylua: ignore
  nnoremap("]w", function() goto_next({ severity = vim.diagnostic.severity.WARN }) end)
  nnoremap("<space>q", vim.diagnostic.setloclist)
end

local function setup()
  config()
  keymap()
  local sign = { Error = "", Warn = "", Hint = "", Info = "" }
  for key, value in pairs(sign) do
    local name = string.format("DiagnosticSign%s", key)
    vim.fn.sign_define(name, { text = value, texthl = name })
  end
end

local function on_attach(_, bufnr)
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
end

M.setup = setup
M.on_attach = on_attach

return M
