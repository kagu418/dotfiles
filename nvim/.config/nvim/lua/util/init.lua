local M = {}

---@param msg string
local function info(msg)
  vim.notify(msg, vim.log.levels.INFO)
end

M.info = info

return M
