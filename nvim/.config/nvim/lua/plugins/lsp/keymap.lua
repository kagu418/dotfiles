local M = {}

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
  nnoremap("gd", function()
    require("telescope.builtin").lsp_definitions(opts)
  end)
  nnoremap("gD", vim.lsp.buf.declaration)
  nnoremap("gT", vim.lsp.buf.type_definition)
  nnoremap("K", vim.lsp.buf.hover)
  nnoremap("<space>gI", vim.lsp.buf.implementation)
  nnoremap("<space>cr", vim.lsp.buf.rename)
  nnoremap("<space>ca", vim.lsp.buf.code_action)
  nnoremap("gr", function()
    require("telescope.builtin").lsp_references(opts)
  end)
  nnoremap("gI", function()
    require("telescope.builtin").lsp_implementations(opts)
  end)
end

M.on_attach = on_attach

return M
