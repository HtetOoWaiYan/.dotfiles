vim.cmd [[
    augroup Intentation
        autocmd!
        autocmd FileType json,jsonc,javascript,javascriptreact,typescript,typescriptreact setlocal tabstop=2 shiftwidth=2 softtabstop=2
    augroup END
]]

-- Relative line number in netrw
vim.cmd([[let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro']])
