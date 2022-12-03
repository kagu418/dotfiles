require("me.autocmd")
require("me.plugins")
require("me.set")
require("me.mappings")
require("me.telescope.mappings")

local plugin_path = "~/ghq/github.com/kagu418"
local plugin_dirs = { "transparent.nvim" }
for _, plugin_dir in ipairs(plugin_dirs) do
  local plugin = string.format("%s/%s", plugin_path, plugin_dir)
  if vim.fn.empty(vim.fn.glob(plugin)) == 0 then
    vim.opt.runtimepath:append(plugin)
  end
end
