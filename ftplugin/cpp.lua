vim.o.makeprg = [[make --no-print-directory -C ../build/]]

-- vim.keymap.set('n', '<Leader>mr', '<Cmd>make | !./%:t:r<CR>',
--     { desc = '[m]ake and [r]un current file' })
