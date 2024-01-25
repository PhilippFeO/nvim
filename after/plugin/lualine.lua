require('lualine').setup {
    options = {
        -- Luline searches for themes in lua/lualine/themes/ dir of every installed plugin
        theme = 'auto', -- `auto` = load theme based on colorscheme
        -- theme = 'kanagawa' works also
        component_separators = '|',
        section_separators = { left = '', right = '' },
    },
    winbar = {
        -- Default config
        -- lualine_a = { 'mode' },
        -- lualine_b = { 'branch', 'diff', 'diagnostics' },
        -- lualine_c = { 'filename' },
        -- lualine_x = { 'encoding', 'fileformat', 'filetype' },
        -- lualine_y = { 'progress' },
        -- lualine_z = { 'location' }
        -- TODO: Damit gibt's keine Icons in DAP Repl. Brauch ich die? <25-01-2024>
        -- lualine_a = { 'mode' },
        -- lualine_b = {},
        -- lualine_c = {},
        -- lualine_x = {},
        -- lualine_y = {},
        -- lualine_z = { 'filename' }
    }
    -- sections = {
    -- lualine_a = {
    --   { 'mode', separator = { left = '',  }, right_padding = 2 },
    -- },
    --   lualine_b = {
    --     { 'branch', fg = '#cc3300' }
    --   }
    -- }
}
