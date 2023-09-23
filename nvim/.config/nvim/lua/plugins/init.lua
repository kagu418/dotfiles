return {
  { "nvim-lua/plenary.nvim" },
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
    event = "CmdlineEnter",
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
    tag = "legacy",
    event = "LspAttach",
    opts = {
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
  },
  {
    "numToStr/Comment.nvim",
    opts = function()
      return {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
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
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
    },
    config = true,
    ft = { "go", "gomod" },
  },
}
