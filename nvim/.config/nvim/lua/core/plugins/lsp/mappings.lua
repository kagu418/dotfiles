local M = {}

local function setup()
  local keymap = require("core.keymap")
  local inoremap = keymap.inoremap
  local nnoremap = keymap.nnoremap

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

M.setup = setup

return M
