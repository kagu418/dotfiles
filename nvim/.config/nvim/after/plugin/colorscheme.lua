vim.opt.background = "dark"

local function find_colorscheme(colorscheme)
  for _, c in ipairs(vim.fn.getcompletion("", "color")) do
    if colorscheme == c then
      return colorscheme
    end
  end
  return "default"
end

local ok = pcall(require, "rose-pine")
if not ok then
  return
end

require("rose-pine").setup({
  dark_variant = "moon",
})

vim.cmd.colorscheme(find_colorscheme("rose-pine"))
