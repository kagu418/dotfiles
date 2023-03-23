return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
  },
  -- stylua: ignore
  keys = {
    {
      "<space>fb", function() require("telescope.builtin").buffers() end,
    },
    {
      "<space>fd",
      function()
        local picker = "find_files"
        local opts = {
          sorting_strategy = "descending",
          scroll_strategy = "cycle",
        }
        if vim.loop.fs_stat(vim.loop.cwd() .. "/.git") then
          picker = "git_files"
          opts.show_untracked = true
        end
        require("telescope.builtin")[picker](opts)
      end,
    },
    {
      "<space>ff",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          border = true,
          previewer = false,
          shorten_path = false,
        }))
      end,
    },
    {
      "<space>fw", function() require("telescope.builtin").grep_string() end,
    },
    {
      "<space>fg", function() require("telescope").extensions.live_grep_args.live_grep_args() end,
    },
    {
      "<space>gc", function() require("telescope.builtin").git_commits() end,
    },
    {
      "<space>gs", function() require("telescope.builtin").git_status() end,
    },
    {
      "<space>gp",
      function()
        require("telescope.builtin").grep_string({
          path_display = { "shorten" },
          search = vim.fn.input({ prompt = "grep for > " }),
        })
      end,
    },
    {
      "<space>so",
      function()
        require("telescope.builtin").vim_options({
          layout_config = {
            width = 0.5,
          },
          sorting_strategy = "ascending",
        })
      end,
    },
    {
      "<space>wt", function() require("telescope.builtin").treesitter() end,
    },
  },
  opts = function()
    local lga_actions = require("telescope-live-grep-args.actions")
    return {
      defaults = {
        mappings = {
          i = {
            ["<C-x>"] = false,
            ["<C-s>"] = function(...)
              require("telescope.actions").select_horizontal(...)
            end,
            ["<C-v>"] = function(...)
              require("telescope.actions").select_vertical(...)
            end,
            ["<C-d>"] = function(...)
              require("telescope.actions").delete_buffer(...)
            end,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            },
          },
        },
      },
      file_previewer = function(...)
        require("telescope.previewers").vim_buffer_cat.new(...)
      end,
      grep_previewer = function(...)
        require("telescope.previewers").vim_buffer_vimgrep.new(...)
      end,
      qflist_previewer = function(...)
        require("telescope.previewers").vim_buffer_qflist.new(...)
      end,
    }
  end,
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("live_grep_args")
  end,
}
