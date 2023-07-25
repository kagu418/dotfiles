return {
  {
    "rose-pine/neovim",
    lazy = false,
    name = "rose-pine",
    priority = 1000,
    opts = {
      dark_variant = "moon",
      highlight_groups = {
        CmpItemKindCopilot = { fg = "foam" },
        IlluminatedWordText = { bg = "highlight_med" },
        IlluminatedWordRead = { bg = "highlight_med" },
        IlluminatedWordWrite = { bg = "highlight_med" },
        InclineNormal = { fg = "rose" },
        InclineNormalNC = { fg = "text" },
        IndentBlanklineIndent1 = { fg = "iris" },
        IndentBlanklineIndent2 = { fg = "foam" },
        IndentBlanklineIndent3 = { fg = "rose" },
        IndentBlanklineIndent4 = { fg = "gold" },
        IndentBlanklineIndent5 = { fg = "pine" },
        IndentBlanklineContext = { fg = "highlight_high" },
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd.colorscheme("rose-pine")
    end,
  },
}
