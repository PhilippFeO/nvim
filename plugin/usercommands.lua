local user_command = vim.api.nvim_create_user_command
user_command('CorrectMD', 'set hlsearch | %s/` \\(.\\{-}\\)`/ `\\1`/gc', {
    desc = 'WORD` CODE` -> WORD `CODE`',
})
