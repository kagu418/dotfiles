if not pcall(require, "telescope") then
  return
end

local telescope = require("me.telescope")
local keymap = require("me.keymap")
local nmap = keymap.nmap

-- files
nmap("<space>fd", telescope.fd)
nmap("<space>ft", telescope.git_files)
nmap("<space>fz", telescope.find_certain_files)
nmap("<space>pp", telescope.project_search)

-- git
nmap("<space>gc", telescope.git_commits)
nmap("<space>gs", telescope.git_status)

-- nvim
nmap("<space>fb", telescope.buffers)
nmap("<space>ff", telescope.current_buffer)
nmap("<space>fi", telescope.all_files)
nmap("<space>fa", telescope.installed_plugins)
nmap("<space>gp", telescope.grep_prompt)
nmap("<space>fw", telescope.grep_cword)
nmap("<space>bo", telescope.vim_options)
nmap("<space>wt", telescope.treesitter)
