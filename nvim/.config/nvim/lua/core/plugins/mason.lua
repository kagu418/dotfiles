local M = {
  "williamboman/mason.nvim",
}

local function config()
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })
end

M.config = config

return M
