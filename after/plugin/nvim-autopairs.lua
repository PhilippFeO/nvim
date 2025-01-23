-- https://github.com/windwp/nvim-autopairs

local npairs = require('nvim-autopairs')

npairs.setup({
    disable_filetype = { 'TelescopePrompt' },
    enable_check_bracket_line = true, -- Don't add pairs if it already has a close pair in the same line

    fast_wrap = {
        map = '<M-i>'
    },

    -- nvim-autopairs integrates with treesitter
    check_ts = true,
    ts_config = {
        lua = { 'string' },
        python = { 'string' }
    }
})

local Rule = require('nvim-autopairs.rule')
-- check_for more information on defining rules:
--  https://github.com/windwp/nvim-autopairs/wiki/Rules-API
-- There was also a „ snippet in main.snippets, which worked
npairs.add_rule(Rule('„', '“')) -- German quotation marks
-- npairs.remove_rule('`') -- remove rule `
