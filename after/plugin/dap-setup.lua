-- bdelete! *dap-terminal* schließt integratedTerminal
-- TODO: nach/mit dap.disconnect() oder dap.close() <17-03-2024>
-- https://github.com/mfussenegger/nvim-dap/issues/278
--
local dap = require('dap')

dap.adapters.my_python_adapter = {
    type = 'executable',
    command = vim.fn.expand '~/.venv/debugpy/bin/python',
    args = { '-m', 'debugpy.adapter' }
}

-- s. `h dap-terminal`
-- Depending on Terminal, an option to execute commands is necessary, but kitty doesn't require one
local command = function()
    if DLR_Machine then
        return vim.fn.expand('/usr/bin/kitty')
    else
        return vim.fn.expand('~/.local/bin/kitty')
    end
end

dap.defaults.fallback.external_terminal = {
    command = command()
}

-- ────────────────────────────────────────

-- dap.defaults.fallback.force_external_terminal = true
-- TODO: README and docs <25-01-2024>
-- Displays variable names next to their definition, uses TreeSitter to find the respective location
require 'nvim-dap-virtual-text'.setup({
    enabled = false
})

-- TODO: Open dapui normally also with tabs of the elements <27-01-2024>

-- ─── signs ──────────
-- `h sign-list`
local wave_colors = require('kanagawa.colors').setup({ theme = 'wave' })
-- There are 'text', 'texthl', 'linehl', 'numhl' as params for sign_define()
vim.api.nvim_set_hl(0, 'DapStopped_texthl', { fg = wave_colors.palette.springGreen })
vim.api.nvim_set_hl(0, 'DapBreakpoint_linehl', { bg = wave_colors.palette.winterGreen })
vim.api.nvim_set_hl(0, 'DapBreakpoint_texthl', { fg = wave_colors.palette.peachRed })
vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint_texthl', linehl = 'DapBreakpoint_linehl', })
vim.fn.sign_define('DapBreakpointCondition',
    { text = '', texthl = 'DapBreakpoint_texthl', linehl = 'DapBreakpoint_linehl', })
vim.fn.sign_define('DapStopped', { text = '󱝁', texthl = 'DapStopped_texthl' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'SignColumn' })


local dapui = require 'dapui'
-- TODO: `h nvim-dap-ui` <25-01-2024>
-- control the panes, s. https://youtu.be/0moS8UHupGc?t=1481
---@diagnostic disable-next-line: missing-fields
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
    ---@diagnostic disable-next-line: missing-fields
    controls = {
        enabled = false,
        ---@diagnostic disable-next-line: missing-fields
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
            size = 45,
            elements = {
                {
                    id = "console",
                    size = 0.2,
                },
                {
                    id = "scopes",
                    size = 0.2
                },
                {
                    id = "breakpoints",
                    size = 0.2
                },
                {
                    id = "stacks",
                    size = 0.2
                },
                {
                    id = "repl",
                    size = 0.2,
                },
            },
        },
        {
            position = "bottom",
            size = 15,
            elements = {
                {
                    id = "watches",
                    size = 1,
                },
            },
        },
    },
}


-- ─── nvim-dap ──────────

-- Open dapui automagically
-- Scheme: Event -> run function
-- TODO: Leave dapui open after debugging test is done, ie. after the `assert` statement. <27-01-2024>
--  No idea how. Probably by writing a function returning `dapui.close` on non pytest debug sessions, but do how do I determine this?
-- `h dap-extensions` seems reasonable to start
dap.listeners.after.event_initialized['dapui_config'] = dapui.open

local function toggle_closing_dapui()
    if not dap.listeners.before.event_terminated['dapui_config'] and not dap.listeners.before.event_exited['dapui_config'] then
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close
    else
        dap.listeners.before.event_terminated['dapui_config'] = nil
        dap.listeners.before.event_exited['dapui_config'] = nil
    end
end
-- Run function, so the default is that dapui closes
toggle_closing_dapui()
vim.keymap.set('n', '<Leader>dt', toggle_closing_dapui, { desc = '[t]oggle closing DAPUI automatically' })


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




-- local my_configs = {
--     require 'dap-configs.python-default'.configs,
--     require 'dap-configs.python-kursverwaltung'.configs,
--     require 'dap-configs.python-tagebuch'.configs,
-- }
--
-- local all_configs = {}
-- for _, list in ipairs(my_configs) do
--     for _, value in ipairs(list) do
--         table.insert(all_configs, value)
--     end
-- end
--
-- -- Make configurations avialable, ie. entry for menu after `h dap.continue()` was called
-- dap.configurations.python = all_configs
