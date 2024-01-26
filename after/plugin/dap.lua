-- TODO: README and docs <25-01-2024>
-- Displays variable names next to their definition, uses TreeSitter to find the respective location
require 'nvim-dap-virtual-text'.setup()


-- ─── nvim-dap-ui ──────────

local dapui = require 'dapui'
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


-- ─── nvim-dap ──────────

local dap = require 'dap'

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
nmap('<Leader>b', dap.toggle_breakpoint, '  Toggle Breakpoint')
nmap('<Leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, '  Toggle Conditional Breakpoint')
nmap('<Leader>dc', dap.terminate, '󰗼  Terminate Debugging')
nmap('<Leader>dr', function()
    dapui.open({ reset = true })
end, '[d]apui [r]eset')
nmap('<Leader>dt', dapui.toggle, '[d]apui [t]oggle')

-- Open dapui automagically
-- Scheme: Event -> run function
-- TODO: Leave dapui open when debugging a (Python) test. <27-01-2024>
--  No idea how. Probably by writing a function returning `dapui.close` on non pytest debug sessions, but do how do I determine this?
-- `h dap-extensions` seems reasonable to start
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- TODO: Read more about configurations. It seems to be an important topic. <27-0127-01-2024
-- This enables debugging Tests in the first place (therefore an important topich).
dap.configurations.python = {
    {
        name = "Pytest: Current File",
        type = "python",
        request = "launch",
        module = "pytest",
        -- TODO: Define args via `pytest.ini`. <27-01-2024>
        args = {
            "${file}",
            "-sv",
            -- "--log-cli-level=INFO",
            -- "--log-file=test_out.log"
        },
        console = "integratedTerminal",
    }
}
