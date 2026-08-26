local user_command = vim.api.nvim_create_user_command
user_command('CorrectMD', 'set hlsearch | %s/` \\(.\\{-}\\)`/ `\\1`/gc', {
    desc = 'WORD` CODE` -> WORD `CODE`',
})

-- By executing :KL the light/dark version of the kanagawa colorscheme is toggled
local kanagawa_toggle = true
user_command('KL', function(_)
    if kanagawa_toggle then
        kanagawa_toggle = not kanagawa_toggle
        vim.cmd('colorscheme kanagawa-lotus')
    else
        kanagawa_toggle = not kanagawa_toggle
        vim.cmd('colorscheme kanagawa')
    end
end, { desc = ':colorscheme kanagawa-lotus' })

user_command('ReloadDAPPythonConfigs', function(_)
        local ok, result = pcall(function()
            return require('dap-configs.load_python_configs').refresh_dap_python_configs()
        end)

        if not ok then
            vim.notify(("Failed reloading DAP Python configs: %s"):format(result), vim.log.levels.ERROR)
        else
            vim.notify(("Reloaded DAP Python configs (%d configs)."):format(#result), vim.log.levels.INFO)
        end
    end,
    { desc = 'Reload DAP Python configs.' }
)


vim.api.nvim_create_user_command(
    'TDBUI',
    function()
        vim.cmd('tabnew | DBUI')
    end,
    { desc = 'Open DBUI in new Tab.' }
)
