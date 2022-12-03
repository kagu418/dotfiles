local keymap = require("me.keymap")
local nmap = keymap.nmap
local inoremap = keymap.inoremap
local nnoremap = keymap.nnoremap
local tnoremap = keymap.tnoremap
local vnoremap = keymap.vnoremap
local xnoremap = keymap.xnoremap

inoremap("<C-c>", "<Esc>")
nnoremap("<space>pv", ":Ex<CR>")

nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

xnoremap("<space>p", '"_dP')
nnoremap("<space>y", '"+y')
vnoremap("<space>y", '"+y')
nmap("<space>Y", '"+Y')

nnoremap("<space>d", '"_d')
vnoremap("<space>d", '"_d')

nnoremap("<space>ev", ":Vex<CR>")
nnoremap("<space>es", ":Sex<CR>")

nnoremap("<C-E>", "copen<CR>")
nnoremap("<C-n>", ":cnext<CR>zz")
nnoremap("<C-p>", ":cprev<CR>zz")

tnoremap("<Leader><Esc>", "<C-\\><C-n>")
tnoremap("<A-h>", "<C-\\><C-n><C-w>h")
tnoremap("<A-j>", "<C-\\><C-n><C-w>j")
tnoremap("<A-k>", "<C-\\><C-n><C-w>k")
tnoremap("<A-l>", "<C-\\><C-n><C-w>l")
