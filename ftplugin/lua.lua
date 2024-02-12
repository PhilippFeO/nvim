-- analogous to ftplugin/markdown.lua
vim.keymap.set('n', '<M-k>', '"hyi`:tab <C-r>h<CR>',
    { buffer = true, desc = 'Open help page reference in Wiki (lua only: <M-k> not K/<S-k>)' })

vim.bo.tabstop = 2
