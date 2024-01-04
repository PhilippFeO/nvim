-- Git push origin HEAD
vim.keymap.set('n', 'gp', '<Cmd>Git push origin HEAD<CR>', { buffer = true, desc = '[g]it [p]ush origin HEAD' })


-- git commit --amend --no-edit
vim.keymap.set('n', 'gcan', '<Cmd>Git commit --amend --no-edit<CR>',
    { buffer = true, desc = '[g]it [c]ommit --[a]mend --no-edit' })
