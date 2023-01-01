local M = {}

local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local lsputil = require("lspconfig.util")

local function all_files()
  builtin.find_files({
    find_command = { "rg", "--no-ignore", "--files" },
    hidden = true,
  })
end

local function find_certain_files()
  builtin.find_files({
    find_command = {
      "rg",
      "--files",
      "--type",
      vim.fn.input({ prompt = "type: " }),
    },
  })
end

local function project_search()
  builtin.find_files({
    find_command = { "rg", "--files" },
    hidden = true,
    sorting_strategy = "descending",
    scroll_strategy = "cycle",
    cwd = lsputil.root_pattern(".git")(vim.fn.expand("%:p")),
  })
end

local function current_buffer()
  builtin.current_buffer_fuzzy_find(themes.get_dropdown({
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }))
end

local function fd()
  builtin.find_files({
    sorting_strategy = "descending",
    scroll_strategy = "cycle",
  })
end

local function git_status()
  builtin.git_status(themes.get_dropdown({
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }))
end

local function git_commits()
  builtin.git_commits(themes.get_dropdown({
    winblend = 5,
  }))
end

local function grep_prompt()
  builtin.grep_string({
    path_display = { "shorten" },
    search = vim.fn.input({ prompt = "grep for > " }),
  })
end

local function grep_cword()
  builtin.grep_string({
    search = vim.fn.expand("<cword>"),
  })
end

local function vim_options()
  builtin.vim_options({
    layout_config = {
      width = 0.5,
    },
    sorting_strategy = "ascending",
  })
end

local function installed_plugins()
  builtin.find_files({
    cwd = string.format("%s/site/pack/packer/start", vim.fn.stdpath("data")),
  })
end

M.buffers = builtin.buffers
M.treesitter = builtin.treesitter
M.all_files = all_files
M.find_certain_files = find_certain_files
M.project_search = project_search
M.current_buffer = current_buffer
M.fd = fd
M.git_files = builtin.git_files
M.git_commits = git_commits
M.git_status = git_status
M.grep_prompt = grep_prompt
M.grep_cword = grep_cword
M.vim_options = vim_options
M.installed_plugins = installed_plugins

return M
