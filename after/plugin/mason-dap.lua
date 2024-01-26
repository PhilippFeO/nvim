-- TODO: README and docs <25-01-2024>
-- Displays variable names next to their definition, uses TreeSitter to find the respective location
require 'nvim-dap-virtual-text'.setup()


local dap = require 'dap'
local dapui = require 'dapui'

-- TODO: Change symbols of Breakpoint and conditional Breakpoint <25-01-2024

-- TODO: README und Doku durchlesen <25-01-2024>
require('mason-nvim-dap').setup {
    -- Makes a best effort to setup the various debuggers with
    -- reasonable debug configurations
    automatic_setup = true,

    -- You'll need to check that you have the required things installed
    -- online, please don't ask me how to install them :)
    ensure_installed = {
        'debugpy', -- s. https://github.com/mfussenegger/nvim-dap-python
    },
}

-- Basic debugging keymaps, feel free to change to your liking!
-- TODO: Log point message, fi. Breakpoint was hit <25-01-2024>
local nmap = function(keys, func, desc)
    if desc then
        desc = ' DAP: ' .. desc
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
    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    controls = {
        icons = {
            -- nerdfonts: search for 'debug_'
            pause = '󰏤',
            play = '▶',
            step_into = '',
            step_over = ' ',
            step_out = '', -- 󰆸
            step_back = ' ',
            run_last = '▶▶',
            terminate = 't ',
        },
    },
}

-- Open dapui automagically
-- Scheme: Event -> run function
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- setup according to https://github.com/mfussenegger/nvim-dap-python
require('dap-python').setup(vim.fn.expand('$VIRTUAL_ENV'))
