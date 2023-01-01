local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
}

local function config()
  require("gitsigns").setup({
    signs = {
      add = {
        hl = "GitSignsAdd",
        text = "▓",
        numhl = "GitSignsAddNr",
        linehl = "GitSignsAddLn",
      },
      change = {
        hl = "GitSignsChange",
        text = "▓",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
    },
    numhl = true,
    on_attach = function(bufnr)
      local signs = package.loaded.gitsigns

      local function keymap(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Navigation
      keymap("n", "]c", function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          signs.next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true })

      keymap("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          signs.prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true })

      -- Actions
      keymap({ "n", "v" }, "<space>hs", ":Gitsigns stage_hunk<CR>")
      keymap({ "n", "v" }, "<space>hr", ":Gitsigns reset_hunk<CR>")
      keymap("n", "<space>hS", signs.stage_buffer)
      keymap("n", "<space>hu", signs.undo_stage_hunk)
      keymap("n", "<space>hR", signs.reset_buffer)
      keymap("n", "<space>hp", signs.preview_hunk)
      keymap("n", "<space>hb", function()
        signs.blame_line({ full = true })
      end)
      keymap("n", "<space>tb", signs.toggle_current_line_blame)
      keymap("n", "<space>hd", signs.diffthis)
      keymap("n", "<space>hD", function()
        signs.diffthis("~")
      end)
      keymap("n", "<space>td", signs.toggle_deleted)

      -- Text object
      keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end,
  })
end

M.config = config

return M
