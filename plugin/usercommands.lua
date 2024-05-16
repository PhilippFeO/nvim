local user_command = vim.api.nvim_create_user_command
user_command('CorrectMD', 'set hlsearch | %s/` \\(.\\{-}\\)`/ `\\1`/gc', {
    desc = 'WORD` CODE` -> WORD `CODE`',
})

-- By executing :KL the light/dark version of the kanagawa colorscheme is toggled
local kanagawa_toggle = true
vim.api.nvim_create_user_command('KL', function(_)
    if kanagawa_toggle then
        kanagawa_toggle = not kanagawa_toggle
        vim.cmd('colorscheme kanagawa-lotus')
    else
        kanagawa_toggle = not kanagawa_toggle
        vim.cmd('colorscheme kanagawa')
    end
end, { desc = ':colorscheme kanagawa-lotus' })
