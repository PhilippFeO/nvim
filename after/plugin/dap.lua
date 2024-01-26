-- TODO: README and docs <25-01-2024>
-- Displays variable names next to their definition, uses TreeSitter to find the respective location
require 'nvim-dap-virtual-text'.setup()

local dap = require 'dap'
local dapui = require 'dapui'


-- Basic debugging keymaps, feel free to change to your liking!
-- TODO: Log point message, fi. Breakpoint was hit <25-01-2024>
-- TODO: Make this function an own plugin using Closures <26-01-2024>
local nmap = function(keys, func, desc)
    if desc then
        desc = '  DAP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { desc = desc })
end
nmap('<F5>', dap.continue) --Entry point for all Debugger things
nmap('<F1>', dap.step_into, '  Step into')
nmap('<F2>', dap.step_over, '  Step over')
nmap('<F3>', dap.step_out, '  Step out')
nmap('<leader>b', dap.toggle_breakpoint, '  Toggle Breakpoint')
nmap('<leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, '  Toggle Conditional Breakpoint')
nmap('<Leader>dc', dap.terminate, '󰗼  Terminate Debugging')


-- TODO: `h nvim-dap-ui` <25-01-2024>
-- Here you fi control the panes, s. https://youtu.be/0moS8UHupGc?t=1481
dapui.setup {
    -- Set icons to characters that are more likely to work in every terminal.
    -- TODO: Highlight Groups dieser ändern, Highlightgroups sollte es in `h nvim-dap-ui` geben
    -- icons = {
    --     expanded = '▾',
    --     collapsed = '▸',
    --     current_frame = '*'
    -- },
    controls = {
        icons = {
            -- nerdfonts: search for 'debug_'
            pause = '󰏤',
            play = '▶',
            step_into = '',
            step_over = '',
            step_out = '', -- 󰆸
            step_back = '',
            run_last = '▶▶',
            terminate = '',
        },
    },
}

nmap('<Leader>dr', function()
    dapui.open({ reset = true })
end, '[d]apui [r]eset')
nmap('<Leader>dt', dapui.toggle, '[d]apui [t]oggle')

-- Open dapui automagically
-- Scheme: Event -> run function
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

dap_python = require('dap-python')
-- setup according to https://github.com/mfussenegger/nvim-dap-python
-- The debugger will automatically pick-up another virtual environment if it is activated before neovim is started.
-- TODO: Using an environment without debugpy also works. I thought it wouldn't. <26-026-01-2024
-- dap_python.setup(vim.fn.expand('$VIRTUAL_ENV'))
--
-- dap.continue does not work, test_method() does
dap_python.setup('~/.venv/debugpy/bin/python')

dap_python.test_runner = 'pytest'
