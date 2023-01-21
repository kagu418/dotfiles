return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost" },
  opts = { delay = 200 },
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
  -- stylua: ignore
  keys = {
    { "]]", function() require("illuminate").goto_next_reference() end },
    { "[[", function() require("illuminate").goto_prev_reference() end },
  },
}
