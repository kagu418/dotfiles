local M = {}

local function diagnostic_open(bufnr)
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

local function on_attach(_, bufnr)
  diagnostic_open(bufnr)
end

M.on_attach = on_attach

return M
