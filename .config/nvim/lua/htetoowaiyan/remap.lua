local Remap = require("htetoowaiyan.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap

inoremap("jk", "<Esc>")

nnoremap("<leader>nrw", "<cmd>Ex<CR>") -- Netrw
nnoremap("<leader><CR>", "o<ESC>")    -- Insert blank line below
nnoremap("<leader>y", "\"+y")         -- Yank to system clipboard
nnoremap("<leader>Y", "gg\"+yG``zz")  -- Yank whole file to system clipboard

vnoremap("<leader>p", "\"_dP")        -- Paste on selected text
vnoremap("<leader>y", "\"+y")         -- Yank selection to system clipboard

vnoremap("J", ":m '>+1<CR>gv=gv")     -- Move selected line up
vnoremap("K", ":m '<-2<CR>gv=gv")     -- Move selected line down

