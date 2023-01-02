local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPre",
}

local char_colors = {
  "#c4a7e7", -- iris
  "#9ccfd8", -- foam
  "#ea9a97", -- rose
  "#f6c177", -- gold
  "#3e8fb0", -- pine
}

local context_colors = {
  "#56526e", -- highlight high
}

---@param name string
---@param colors string[]
---@return string[]
local function hl_list(name, colors)
  local list = {}
  for i, color in ipairs(colors) do
    list[i] = string.format("%s%d", name, i)
    vim.api.nvim_set_hl(0, list[i], { fg = color, nocombine = true })
  end
  return list
end

local function config()
  require("indent_blankline").setup({
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
    char_highlight_list = hl_list("IndentBlanklineIndent", char_colors),
    context_highlight_list = hl_list("IndentBlanklineContext", context_colors),
  })
end

M.config = config

return M
