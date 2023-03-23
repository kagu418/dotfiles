return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      sections = {
        lualine_c = {
          {
            "filename",
            path = 1,
            shorting_target = 40,
          },
        -- stylua: ignore
        {
          function() return require("nvim-navic").get_location() end,
          cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
        },
        },
        lualine_x = {
          "encoding",
          {
            "fileformat",
            symbols = {
              unix = "unix",
              dos = "dos",
              mac = "mac",
            },
          },
          {
            "filetype",
            colored = false,
            icon = { align = "left" },
          },
        },
      },
    },
  },
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    opts = {
      window = {
        margin = {
          horizontal = 1,
          vertical = 0,
        },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        local icon, color = require("nvim-web-devicons").get_icon_color(filename)
        return {
          { icon, guifg = color },
          { " " },
          { filename },
        }
      end,
    },
  },
  {
    "SmiteshP/nvim-navic",
    init = function()
      vim.g.navic_silence = true
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, args.buf)
          end
        end,
      })
    end,
    opts = { separator = " ", highlight = true, depth_limit = 5 },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    opts = {
      space_char_blankline = " ",
      show_current_context = true,
      show_current_context_start = true,
      char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
      },
      context_highlight_list = { "IndentBlanklineContext" },
    },
  },
  {
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
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = true,
  },
}
