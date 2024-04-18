-- TODO: README and docs <25-01-2024>
-- Displays variable names next to their definition, uses TreeSitter to find the respective location
require 'nvim-dap-virtual-text'.setup()


-- ─── nvim-dap-ui ──────────
-- TODO: Open dapui normally also with tabs of the elements <27-01-2024>

local wave_colors = require('kanagawa.colors').setup({ theme = 'wave' })
vim.api.nvim_set_hl(0, 'breakpoint_linehl', { bg = wave_colors.palette.winterGreen })
vim.api.nvim_set_hl(0, 'DapBreakpoint_texthl', { fg = wave_colors.palette.springGreen })
-- There is also 'DapStopped'
-- TODO: Name of sign for conditional breakpoint <27-01-2024>
vim.fn.sign_define('DapBreakpoint', {
    text = '',
    texthl = 'DapBreakpoint_texthl',
    linehl = 'breakpoint_linehl',
    numhl = ''
})

local dapui = require 'dapui'
-- TODO: `h nvim-dap-ui` <25-01-2024>
-- Here you fi control the panes, s. https://youtu.be/0moS8UHupGc?t=1481
dapui.setup {
    -- TODO: Highlight Groups dieser ändern, Highlightgroups sollte es in `h nvim-dap-ui` geben
    icons = {
        expanded = '▾',
        collapsed = '▸',
        current_frame = '*'
    },
    mappings = {
        remove = 'dd'
    },
    controls = {
        icons = {
            -- nerdfonts: search for 'debug_'
            pause = '󰏤',
            play = '▶',
            run_last = '▶▶',
        },
    },
    layouts = {
        {
            position = "left",
            size = 60,
            elements = { {
                id = "scopes",
                size = 0.35
            }, {
                id = "watches",
                size = 0.35
            }, {
                id = "breakpoints",
                size = 0.1
            }, {
                id = "stacks",
                size = 0.2
            } },
        },
        {
            position = "bottom",
            size = 7,
            elements = { {
                id = "repl",
                size = 0.5
            }, {
                id = "console",
                size = 0.5
            } },
        }
    },
}


-- ─── nvim-dap ──────────

local dap = require 'dap'

-- Open dapui automagically
-- Scheme: Event -> run function
-- TODO: Leave dapui open after debugging test is done, ie. after the `assert` statement. <27-01-2024>
--  No idea how. Probably by writing a function returning `dapui.close` on non pytest debug sessions, but do how do I determine this?
-- `h dap-extensions` seems reasonable to start
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- ─── dap & dapui keymaps ──────────

-- Basic debugging keymaps, feel free to change to your liking!
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
nmap('<F4>', dap.step_back, ' Step out')

nmap('<Leader>bb', dap.toggle_breakpoint, '  Toggle Breakpoint')
nmap('<Leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, '  Toggle Conditional Breakpoint')
nmap('<Leader>lb', function()
    dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, 'Set [l]ogging [b]reakpoint')

nmap('<Leader>dc', dap.terminate, '󰗼  Terminate Debugging')
nmap('<Leader>dl', dap.run_last, '[d]ebug with [l]ast configuration')
nmap('<Leader>dr', function()
    dapui.open({ reset = true })
end, '[d]apui [r]eset')
nmap('<Leader>du', dapui.toggle, '[d]ap[u]i toggle')

-- Having this in `dap-python-configs` doesn't enable `integratedTerminal`
dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

-- TODO: Both keymaps below don't work <27-01-2024>
-- But starting with `dap.continue()` does, ie. selecting the Pytest configuration.
-- Error message: The selected configuration references adapter `nil`, but dap.adapters.nil is undefined
-- s. `h dap-adapter` for using with functions
-- Intended as test case to check whether my adapter is called (it is after selecting the config after `dap.continue()` call)
-- dap.adapters.my_python_adapter = function(callback, config)
--     -- print('My adapter')
--     callback({
--         type = 'executable',
--         command = os.getenv('HOME') .. '/.venv/debugpy/bin/python',
--         args = { '-m', 'debugpy.adapter' }
--     })
-- end
-- TODO: requiring also doesn't work <28-01-2024>
--  Maybe it helps: https://stackoverflow.com/questions/73342386/can-you-require-a-file-directly-from-the-after-plugin-folder
-- local dap_pytest_config = require('after.plugin.dap-python-configs').dap_pytest_config
-- nmap('<Leader>dt', function()
--     dap.run({ dap_pytest_config })
-- end, '[d]ebug [t]est')
-- -- Use default python config. `[2]` because my own is inserted before.
-- nmap('<Leader>df', function()
--     dap.run({ dap.configurations.python[2] })
-- end, '[d]ebug [f]ile')
