local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind-nvim",
  },
}

local function config()
  local cmp = require("cmp")

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete({}),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
      { name = "buffer", keyword_length = 4 },
    }),
    formatting = {
      format = require("lspkind").cmp_format({
        maxwidth = 50,
        with_text = true,
        menu = {
          nvim_lsp = "[LSP]",
          luasnip = "[snip]",
          path = "[path]",
          buffer = "[buf]",
        },
      }),
    },
    experimental = {
      native_menu = false,
      ghost_text = true,
    },
  })
end

M.config = config

return M
