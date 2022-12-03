local remove_postspace = vim.api.nvim_create_augroup("RemovePostspace", {})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = remove_postspace,
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

local highlight_on_yank = vim.api.nvim_create_augroup("HighlightOnYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_on_yank,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 50,
    })
  end,
})
