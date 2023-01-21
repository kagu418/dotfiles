return {
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-tree/nvim-web-devicons",
    config = true,
  },
  {
    "rose-pine/neovim",
    config = function()
      require("rose-pine").setup({
        dark_variant = "moon",
      })
      vim.cmd.colorscheme("rose-pine")
    end,
    name = "rose-pine",
    lazy = false,
    priority = 1000,
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
  },
  {
    "Wansmer/treesj",
    config = true,
    keys = {
      { "<space>m" },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    config = true,
  },
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "GBrowse" },
    dependencies = {
      "tpope/vim-rhubarb",
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
  },
  {
    "j-hui/fidget.nvim",
    config = {
      text = {
        spinner = "moon",
      },
      align = {
        bottom = true,
      },
      window = {
        relative = "editor",
      },
    },
    event = "BufReadPre",
  },
  {
    "numToStr/Comment.nvim",
    config = true,
    keys = {
      { "gcc", vim.cmd.comment_toggle_linewise_count },
      { "gc", vim.cmd.comment_toggle_linewise_visual, mode = "v" },
    },
  },
  {
    "jeffkreeftmeijer/vim-numbertoggle",
    event = "InsertEnter",
  },
  {
    "windwp/nvim-autopairs",
    config = true,
    event = "BufReadPre",
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  {
    "tpope/vim-dispatch",
    cmd = { "Dispatch", "Focus", "Make", "Start" },
  },
  {
    "tpope/vim-repeat",
    event = "BufReadPre",
  },
  {
    "kylechui/nvim-surround",
    event = "BufReadPre",
    config = true,
  },
}
