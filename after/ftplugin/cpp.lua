if DLR_Machine then
    vim.cmd.compiler('cpp')

    vim.keymap.set('n', '<Leader>mm', '<Cmd>w | make -j8 | cwindow 12 | wincmd k<CR>',
        { desc = 'make/compile/execute current file with -j8' })

    vim.keymap.set('n', '<Leader>cm',
        '<Cmd>!cd ../build && cmake ../src && cd -<CR>',
        { desc = '[cm]ake ../src in build/' })
end
