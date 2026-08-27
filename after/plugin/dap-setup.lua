-- bdelete! *dap-terminal* schließt integratedTerminal
-- TODO: nach/mit dap.disconnect() oder dap.close() <17-03-2024>
-- https://github.com/mfussenegger/nvim-dap/issues/278

local dap = require('dap')

dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = "Attach to running Neovim instance",
    }
}


dap.adapters.nlua = function(callback, config)
    callback({
        type = 'server',
        host = config.host or "127.0.0.1",
        port = config.port or 8086,
    })
end

dap.adapters.my_python_adapter = {
    type = 'executable',
    command = vim.g.python3_host_prog,
    -- command = LINUX_OR_WINDOWS(
    --     vim.fn.stdpath('config') .. '/.venv/neovim/bin/python',
    --     vim.fn.stdpath('config') .. '/.venv/neovim/Scripts/pythonw.exe'
    -- ),
    args = { '-m', 'debugpy.adapter' }
}

-- s. `h dap-terminal`
-- Depending on Terminal, an option to execute commands is necessary (but kitty doesn't require one)
dap.defaults.fallback.external_terminal = {
    command = LINUX_OR_WINDOWS(
        vim.fn.expand('~/.local/bin/kitty'),
        "C:\\Program Files\\WindowsApps\\Microsoft.PowerShell_7.6.1.0_x64__8wekyb3d8bbwe\\pwsh.exe"
    )
}
-- Having this in `dap-python-configs` doesn't enable `integratedTerminal`
-- dap.defaults.fallback.terminal_win_cmd = '50vsplit new'
dap.defaults.fallback.focus_terminal = false
-- `h dap-view-switchbuf`
-- Multiple options or function possible
-- 'useopen': if the frame's buffer is already open in some window in the
-- current tab, switch focus to that window instead of loading the buffer
-- into whatever window currently has focus (s. `switchbuf_fn.useopen()` in
-- nvim-dap's session.lua). 'usetab' additionally searches other tabpages.
-- Neither ever opens a new window -- if the target buffer isn't open
-- anywhere (e.g. stepping into Lua runtime/plugin files you don't have open,
-- as when debugging Neovim itself), both fail and nvim-dap just warns
-- ("switchbuf setting prevented jump to location") without navigating at
-- all. 'uselast' is the final fallback for that case -- it never fails, it
-- just loads the buffer into the current or alternate window.
dap.defaults.fallback.switchbuf = 'useopen,usetab,uselast'
dap.defaults.fallback.force_external_terminal = false

-- ────────────────────────────────────────

-- TODO: README and docs <25-01-2024>
-- Displays variable names next to their definition, uses TreeSitter to find the respective location
require 'nvim-dap-virtual-text'.setup({
    enabled = false
})


-- Load DAP Configs
-- ────────────────
-- DAP configuration settings: https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
-- ─── Python ──────────
-- s. also autocommands.lua
-- print(vim.inspect(dap.configurations.python))
require('dap-configs.load_python_configs').refresh_dap_python_configs()


-- ─── Signs ──────────
-- `h sign-list`
local wave_colors = require('kanagawa.colors').setup({ theme = 'wave' })
-- There are 'text', 'texthl', 'linehl', 'numhl' as params for sign_define()
vim.api.nvim_set_hl(0, 'DapStopped_texthl', { fg = wave_colors.palette.springGreen })
vim.api.nvim_set_hl(0, 'DapBreakpoint_linehl', { bg = wave_colors.palette.winterGreen })
vim.api.nvim_set_hl(0, 'DapBreakpoint_texthl', { fg = wave_colors.palette.peachRed })


-- Probably deprecated
-- `h diagnostic-signs`
-- `h vim.diagnostic.config()`
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

-- Open dapui automaticly
-- Scheme: Event -> run function
-- TODO: Leave dapui open after debugging test is done, ie. after the `assert` statement. <27-01-2024>
--  No idea how. Probably by writing a function returning `dapui.close` on non pytest debug sessions, but do how do I determine this?
-- `h dap-extensions` seems reasonable to start

-- dap.listeners.after.event_initialized['dapui_config'] = dapui.open

-- Automatically break on uncaught exceptions whenever a debug session starts
dap.listeners.after.event_initialized['exception_breakpoints'] = function()
    dap.set_exception_breakpoints({ 'uncaught' })
end
local function toggle_closing_dapui()
    dap.listeners.after.event_initialized["dap-view"] = nil
    dap.listeners.before.event_terminated["dap-view"] = nil
    dap.listeners.before.event_exited["dap-view"] = nil
    -- if not dap.listeners.before.event_terminated['dapui_config'] and not dap.listeners.before.event_exited['dapui_config'] then
    --     dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    --     dap.listeners.before.event_exited['dapui_config'] = dapui.close
    -- else
    --     dap.listeners.before.event_terminated['dapui_config'] = nil
    --     dap.listeners.before.event_exited['dapui_config'] = nil
    --     dap.listeners.after.event_terminated['dapui_config'] = nil
    --     dap.listeners.after.event_exited['dapui_config'] = nil
    -- end
end
-- Run function, so the default is that dapui closes
toggle_closing_dapui()
vim.keymap.set('n', '<Leader>dt', toggle_closing_dapui, { desc = '[t]oggle closing DAPUI automatically' })



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
