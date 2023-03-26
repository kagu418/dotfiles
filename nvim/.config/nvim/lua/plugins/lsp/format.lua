local M = {
  autoformat = true,
}

local function toggle()
  M.autoformat = not M.autoformat
  if M.autoformat then
    vim.notify("enabled format on save", vim.log.levels.INFO)
  else
    vim.notify("disabled format on save", vim.log.levels.INFO)
  end
end

local function on_attach(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup(string.format("LspFormat.%d", bufnr), {}),
      buffer = bufnr,
      callback = function()
        if M.autoformat then
          vim.lsp.buf.format({
            bufnr = bufnr,
            ---@diagnostic disable-next-line: redefined-local
            filter = function(client)
              return client.name == "null-ls"
            end,
          })
        end
      end,
    })
  end
end

M.toggle = toggle
M.on_attach = on_attach

return M
