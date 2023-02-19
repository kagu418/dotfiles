return {
  "stevearc/dressing.nvim",
  init = function()
    local lazy = package.loaded.lazy

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      lazy.load({ plugins = { "dressing.nvim" } })
      return vim.ui.select(...)
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.input = function(...)
      lazy.load({ plugins = { "dressing.nvim" } })
      return vim.ui.input(...)
    end
  end,
}
