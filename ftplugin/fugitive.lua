-- ─── git push ──────────
-- Git push origin HEAD
vim.keymap.set('n', 'gp', '<Cmd>Git push origin HEAD<CR>', { buffer = true, desc = '[g]it [p]ush origin HEAD' })

-- ─── git commit ──────────
-- git commit --amend --no-edit
vim.keymap.set('n', 'gca', '<Cmd>Git commit --amend --no-edit<CR>',
    { buffer = true, desc = '[g]it [c]ommit --[a]mend --no-edit' })

-- ─── git log ──────────
-- git log --graph
vim.keymap.set('n', 'gll', '<Cmd>Git log --graph<CR>', { buffer = true, desc = '[g]it [l]og --graph' })
-- git log --graph --all -15
vim.keymap.set('n', 'gla', '<Cmd>Git log --graph --all -15<CR>',
    { buffer = true, desc = '[g]it [l]og --graph --[a]ll -15' })
