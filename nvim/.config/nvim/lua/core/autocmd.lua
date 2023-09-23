vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("RemovePostspace", {}),
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightOnYank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 50,
    })
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("ResizeSplit", {}),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})
