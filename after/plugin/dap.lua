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
nmap('<Leader>b', dap.toggle_breakpoint, '  Toggle Breakpoint')
nmap('<Leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, '  Toggle Conditional Breakpoint')

nmap('<Leader>dc', dap.terminate, '󰗼  Terminate Debugging')
nmap('<Leader>dr', function()
    dapui.open({ reset = true })
end, '[d]apui [r]eset')
nmap('<Leader>du', dapui.toggle, '[d]ap[u]i toggle')


-- This enables debugging Tests in the first place.
-- More information in my Wiki
local dap_pytest_config = {
    name = "Pytest: Current File",
    -- type = "python",
    type = "my_python_adapter",
    request = "launch", -- or 'attach' TODO: What does attach? <27-01-2024>
    module = "pytest",
    -- TODO: Define args via `pytest.ini`. <27-01-2024>
    args = {
        "${file}",
        "-sv",
        -- "--log-cli-level=INFO",
        -- "--log-file=test_out.log"
    },
    console = "integratedTerminal",
    -- console = 'externalTerminal',
    -- python_path = '~/.venv/recipe-selector/bin/python',
    -- debugOptions = { 'RedirectOutput' },
}

local dap_py_ex_term = {
    console = 'externalTerminal',
    name = "Debug with externalTerminal",
    program = "${file}",
    request = "launch",
    type = "python"
}
-- s. `h dap-terminal`
-- Depending on Terminal, an option to execute commands is necessary, but kitty doesn't require one
dap.defaults.fallback.external_terminal = {
    command = '/home/philipp/.local/bin/kitty'
}
-- dap.defaults.fallback.force_external_terminal = true

-- Not useable for complex issues like starting Neovim in subprocess
local dap_py_in_term = {
    console = 'integratedTerminal',
    name = "Debug with integratedTerminal",
    program = "${file}",
    request = "launch",
    type = "python"
}
dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

-- Make configuration avialable, ie. entry for menu after `h dap.continue()` was called
dap.configurations.python = {
    dap_py_ex_term,
    dap_pytest_config,
    dap_py_in_term,
}

-- TODO: Both keymaps below don't work <27-01-2024>
-- But starting with `dap.continue()` does, ie. selecting the Pytest configuration.
-- Error message: The selected configuration references adapter `nil`, but dap.adapters.nil is undefined
dap.adapters.my_python_adapter = {
    type = 'executable',
    command = os.getenv('HOME') .. '/.venv/debugpy/bin/python',
    args = { '-m', 'debugpy.adapter' }
}
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
nmap('<Leader>dt', function()
    dap.run({ dap_pytest_config })
end, '[d]ebug [t]est')
-- Use default python config. `[2]` because my own is inserted before.
nmap('<Leader>df', function()
    dap.run({ dap.configurations.python[2] })
end, '[d]ebug [f]ile')


-- ─── Codelldb ──────────
-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
-- https://github.com/vadimcn/codelldb
dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        -- Mason installs everyting into `stdpath('data')/mason`,
        -- defaults to ~/.local/share/nvim/mason/.
        command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
        args = { "--port", "${port}" },
    }
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            -- TODO: Insert main file/starting point automatically <27-01-2024>
            -- Easy for one file projects but that's not the default.
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}
