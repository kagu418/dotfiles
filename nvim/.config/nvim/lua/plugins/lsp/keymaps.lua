local M = {}

local function goto_prev(opts)
  vim.diagnostic.goto_prev(opts)
  vim.api.nvim_feedkeys("zz", "n", false)
end

local function goto_next(opts)
  vim.diagnostic.goto_next(opts)
  vim.api.nvim_feedkeys("zz", "n", false)
end

local function on_attach(_, bufnr)
  local keymap = require("core.keymap")
  -- stylua: ignore
  local inoremap = function(lhs, rhs) return keymap.inoremap(lhs, rhs, { buffer = bufnr }) end
  -- stylua: ignore
  local nnoremap = function(lhs, rhs) return keymap.nnoremap(lhs, rhs, { buffer = bufnr }) end

  local opts = {
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    ignore_filename = false,
    show_line = false,
  }

  inoremap("<C-k>", vim.lsp.buf.signature_help)
  -- stylua: ignore
  nnoremap("gd", function() require("telescope.builtin").lsp_definitions(opts) end)
  nnoremap("gD", vim.lsp.buf.declaration)
  nnoremap("gT", vim.lsp.buf.type_definition)
  nnoremap("K", vim.lsp.buf.hover)
  nnoremap("<space>gI", vim.lsp.buf.implementation)
  nnoremap("<space>cr", vim.lsp.buf.rename)
  nnoremap("<space>ca", vim.lsp.buf.code_action)
  -- stylua: ignore
  nnoremap("gr", function() require("telescope.builtin").lsp_references(opts) end)
  -- stylua: ignore
  nnoremap("gI", function() require("telescope.builtin").lsp_implementations(opts) end)

  nnoremap("<space>e", vim.diagnostic.open_float)
  nnoremap("<space>q", vim.diagnostic.setloclist)
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
end

M.on_attach = on_attach

return M
