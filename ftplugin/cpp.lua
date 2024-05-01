vim.cmd.compiler('cpp')

vim.keymap.set('n', '<Leader>cm',
    '<Cmd>!cd ../build && cmake ../src && cd -<CR>',
    { desc = '[cm]ake ../src in build/' })
