local user_command = vim.api.nvim_create_user_command
user_command('CorrectMD', 'set hlsearch | %s/` \\(.\\{-}\\)`/ `\\1`/gc', {
    desc = 'WORD` CODE` -> WORD `CODE`',
})

vim.api.nvim_create_user_command('KL', 'colorscheme kanagawa-lotus', { desc = ':colorscheme kanagawa-lotus' })
