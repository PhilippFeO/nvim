-- Events: QuickFixCmdPre, QuickFixCmdPost

-- Window local highlighting; may be overwritten by namespaces
--      Background 1: Highlights are global, ie. `vim.api.nvim_set_hl(0, "LineNr", { fg = '#ffffff' })` triggered in a qf-window changes the Line numbering in every other window. The `winhighlight` option offers a way around this.
--      Background 2: I didn't like that the line number between |n| was barely visible.
local colors = require('kanagawa.colors').setup()
local cp = colors.palette
vim.api.nvim_set_hl(0, 'MyLineNr', { fg = cp.sakuraPink })
vim.o.winhighlight = 'LineNr:MyLineNr'


vim.api.nvim_create_autocmd(
    'FileType', {
        group = vim.api.nvim_create_augroup('Quickfix-List-Window', { clear = true }),
        pattern = 'qf',
        -- Alternative: :botright cwindow
        command = vim.cmd.wincmd('J'),
        desc = 'Spread Quickfix-List over full breadth when using splits'
    }
)
