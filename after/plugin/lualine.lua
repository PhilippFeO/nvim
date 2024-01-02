require('lualine').setup {
    options = {
        -- Luline searches for themes in lua/lualine/themes/ dir of every installed plugin
        theme = 'auto', -- `auto` = load theme based on colorscheme
        -- theme = 'kanagawa' works also
        component_separators = '|',
        section_separators = { left = '', right = '' },
    },
    -- sections = {
    -- lualine_a = {
    --   { 'mode', separator = { left = '',  }, right_padding = 2 },
    -- },
    --   lualine_b = {
    --     { 'branch', fg = '#cc3300' }
    --   }
    -- }
}
