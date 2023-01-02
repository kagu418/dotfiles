local util = require("util")

local M = {
  autoformat = true,
}

local lsp_formatting = vim.api.nvim_create_augroup("LspFormatting", {})

local function setup(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = lsp_formatting, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lsp_formatting,
      buffer = bufnr,
      callback = function()
        if M.autoformat then
          vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function()
              return client.name == "null-ls"
            end,
          })
        end
      end,
    })
  end
end

local function toggle()
  M.autoformat = not M.autoformat
  if M.autoformat then
    util.info("enabled format on save")
  else
    util.info("disabled format on save")
  end
end

M.setup = setup
M.toggle = toggle

return M
