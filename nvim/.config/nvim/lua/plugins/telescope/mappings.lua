local M = {}

local function setup()
  local fn = require("plugins.telescope.function")
  local nmap = require("core.keymap").nmap

  nmap("<space>fd", fn.fd)
  nmap("<space>ft", fn.git_files)
  nmap("<space>fz", fn.find_certain_files)
  nmap("<space>pp", fn.project_search)
  nmap("<space>gc", fn.git_commits)
  nmap("<space>gs", fn.git_status)
  nmap("<space>fb", fn.buffers)
  nmap("<space>ff", fn.current_buffer)
  nmap("<space>fi", fn.all_files)
  nmap("<space>fa", fn.installed_plugins)
  nmap("<space>gp", fn.grep_prompt)
  nmap("<space>fw", fn.grep_cword)
  nmap("<space>bo", fn.vim_options)
  nmap("<space>wt", fn.treesitter)
end

M.setup = setup

return M
