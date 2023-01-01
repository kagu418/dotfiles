local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
  },
  keys = {
    { "<space>fd" },
  },
}

local function config()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local previewers = require("telescope.previewers")
  require("core.plugins.telescope.mappings").setup()

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<C-x>"] = false,
          ["<C-s>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-d>"] = actions.delete_buffer,
        },
      },
    },
    pickers = {},
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
    },
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
  })
  telescope.load_extension("fzf")
  telescope.load_extension("ui-select")
end

M.config = config

return M
