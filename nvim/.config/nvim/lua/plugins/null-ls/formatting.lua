local M = {
  autoformat = true,
}

local function setup(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    local lsp_formatting = vim.api.nvim_create_augroup("LspFormatting", {})
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
    vim.notify("enabled format on save", vim.log.levels.INFO, { title = "Formatting" })
  else
    vim.notify("disabled format on save", vim.log.levels.INFO, { title = "Formatting" })
  end
end

M.setup = setup
M.toggle = toggle

return M
