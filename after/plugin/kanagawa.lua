require('kanagawa').setup({
    colors = {
        theme = {
            all = {
                ui = {
                    -- no background for signs in signcolumn
                    bg_gutter = 'none'
                }
            }
        }
    },
    -- overrides = function(colors)
    --     return {
    --         ['@text.diff.add'] = { fg = "blue" },
    --     }
    -- end
})

vim.cmd.colorscheme 'kanagawa'
