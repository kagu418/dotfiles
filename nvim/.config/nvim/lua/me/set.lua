vim.g.mapleader = ","
vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_preview = 1
vim.g.netrw_winsize = 25
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_vimball = 1
vim.g.loadedvimballPlugin = 1

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.wrap = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars:prepend("trail:·")
vim.opt.listchars:prepend("tab:» ")
vim.opt.clipboard:append({ "unnamedplus" })
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.joinspaces = false
vim.opt.mouse = "n"
vim.opt.belloff = "all"
vim.opt.pumblend = 10
vim.opt.wildoptions = "pum"
vim.opt.showmatch = true
vim.opt.updatetime = 50
vim.opt.splitright = true
vim.opt.splitbelow = true
