-- ╭─────────────────────────────────────╮
-- │ numToStr/Comment.nvim configuration │
-- ╰─────────────────────────────────────╯
-- Link: https://github.com/numToStr/Comment.nvim
-- This is currently (2023-04-01) the default configuration. Inserted for the sake of completeness and to have inspiration in the future.

require('Comment').setup({
    mappings = {
        -- Enable operator-pending mapping
        --  `gcc`     Line-wise comment for current line
        --  `gbc`     Block-wise comment for current line
        --  `gc[count]{motion}`   Line-wise comment for [count] {motion}s
        --  `gb[count]{motion}`   Block-wise comment for [count] {motion}s
        basic = true,
        -- Enable extra mapping
        --  `gco`   Start comment in line below
        --  `gcO`   Start comment in line above
        --  `gcA`   Start comment at end of line
        extra = true,
    },
    -- LHS of extra mappings (s. `extra = true`)
    extra = {
        -- Add comment on the line below
        below = 'gco',
        -- Add comment on the line above
        above = 'gcO',
        -- Add comment at the end of line
        eol = 'gcA',
    },
    -- Add a space b/w comment and the line
    padding = true,
    -- Whether the cursor should stay at its position
    sticky = true,
    -- Lines to be ignored while (un)comment
    --  Lua-Regex, when matches lines are ignored
    --  Example: Lines already starting with a comment string
    ignore = nil,
    -- LHS of toggle mappings in NORMAL mode
    toggler = {
        -- Line-comment toggle keymap
        line = 'gcc',
        -- Block-comment toggle keymap
        block = 'gbc',
    },
    -- LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        -- Line-comment keymap
        line = 'gc',
        -- Block-comment keymap
        block = 'gb',
    },
    -- Function to call before (un)comment
    pre_hook = nil,
    -- Function to call after (un)comment
    post_hook = nil,
})
