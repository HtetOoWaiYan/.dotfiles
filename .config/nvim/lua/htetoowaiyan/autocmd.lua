vim.cmd [[
    augroup Intentation
        autocmd!
        autocmd FileType jsonc,javascript,javascriptreact,typescript,typescriptreact setlocal tabstop=2 shiftwidth=2 softtabstop=2
    augroup END
]]
