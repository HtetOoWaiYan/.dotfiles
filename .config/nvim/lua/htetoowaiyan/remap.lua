local Remap = require("htetoowaiyan.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
-- local xnoremap = Remap.xnoremap
-- local nmap = Remap.nmap

inoremap("jk", "<Esc>")

nnoremap("<C-n>", "<cmd>Ex<CR>")      -- Netrw

nnoremap("<C-d>", "<C-d>zz")          -- Scroll down half page & center cursor
nnoremap("<C-u>", "<C-u>zz")          -- Scroll up half page & center cursor
nnoremap("n", "nzzzv")                -- Next search result & center cursor
nnoremap("N", "Nzzzv")                -- Previous search result & center cursor

nnoremap("<leader><CR>", "o<ESC>")    -- Insert blank line below
nnoremap("<leader>y", "\"+y")         -- Yank to system clipboard
nnoremap("<leader>Y", "gg\"+yG``zz")  -- Yank whole file to system clipboard

nnoremap("<leader>f", vim.lsp.buf.format) -- Format buffer

vnoremap("<leader>p", "\"_dP")        -- Paste on selected text
vnoremap("<leader>y", "\"+y")         -- Yank selection to system clipboard

vnoremap("<C-j>", ":m '>+1<CR>gv=gv") -- Move selected line up
vnoremap("<C-k>", ":m '<-2<CR>gv=gv") -- Move selected line down

