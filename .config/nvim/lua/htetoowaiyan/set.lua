vim.opt.termguicolors = true

vim.opt.guicursor = ""
vim.opt.cursorline = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.wrap = true
vim.opt.scrolloff = 8

vim.opt.signcolumn = "yes"

vim.opt.swapfile = false
vim.opt.backup = false

vim.g.mapleader = " "

-- Netrw
vim.g.netrw_localcopydircmd = "cp -r"

-- CamelCaseMotion.vim
vim.g.camelcasemotion_key = "<leader>"

-- denols
vim.g.markdown_fenced_languages = {
    "ts=typescript"
}
