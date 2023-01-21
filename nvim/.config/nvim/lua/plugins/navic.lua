return {
  "SmiteshP/nvim-navic",
  init = function()
    vim.g.navic_silence = true
  end,
  opts = { separator = " ", highlight = true, depth_limit = 5 },
}
