vim.o.makeprg = [[make --no-print-directory -C ../build/]]

vim.keymap.set('n', '<Leader>cm', '<Cmd>!cd ../build && cmake ../src<CR>',
    { desc = '[cm]ake ../src in build/' })