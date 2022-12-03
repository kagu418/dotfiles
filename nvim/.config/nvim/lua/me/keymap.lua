local M = {}

---@param mode string|table
---@param init table|nil
---@return fun(lhs: string, rhs: string|function, opts?: table)
local function bind(mode, init)
  init = init or { noremap = true }
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force", init, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
  end
 end

M.nmap = bind("n", { noremap = false })
M.inoremap = bind("i")
M.nnoremap = bind("n")
M.tnoremap = bind("t")
M.vnoremap = bind("v")
M.xnoremap = bind("x")

return M
