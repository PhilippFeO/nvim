-- Debugpy configurations:
-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings


-- bdelete! *dap-termina* schließt integratedTerminal
-- TODO: nach/mit dap.disconnect() oder dap.close() <17-03-2024>
-- https://github.com/mfussenegger/nvim-dap/issues/278


local dap = require('dap')

dap.adapters.my_python_adapter = {
    type = 'executable',
    command = vim.fn.expand '~/.venv/debugpy/bin/python',
    args = { '-m', 'debugpy.adapter' }
}

-- s. `h dap-terminal`
-- Depending on Terminal, an option to execute commands is necessary, but kitty doesn't require one
local command = function()
    if vim.fn.hostname() == 'klapprechner' then
        return vim.fn.expand('~/.local/bin/kitty')
    else
        return vim.fn.expand('/usr/bin/kitty')
    end
end
dap.defaults.fallback.external_terminal = {
    command = command()
}
-- dap.defaults.fallback.force_external_terminal = true


-- ─── Configurations ──────────

-- This enables debugging Tests in the first place.
-- More information in my Wiki
local dap_pytest_config = {
    name = "Pytest: Current File",
    type = "python",
    request = "launch", -- or 'attach' TODO: What does attach? <27-01-2024>
    module = "pytest",
    -- TODO: Define args via `pytest.ini`. <27-01-2024>
    args = {
        "${file}",
        "-rA",
        "-s",
        -- "--log-cli-level=INFO",
        -- "--log-file=test_out.log"
    },
    -- integratedTerminal: Terminal in split next to Code; doesn't close on dap.disconnect()
    -- externalTerminal: own terminal window for output
    -- internalConsole: print output in dap-repl window (default)
    -- console = "integratedTerminal",
    -- If true and console = 'externalTerminal', then output is printed in 'externalTerminal' only
    -- If false, then no ouput is printed
    redirectOutput = true,
    -- Display return value of function in DAP Scopes window
    showReturnValue = false,
}

local dap_py_exTerm = {
    console = 'externalTerminal',
    name = "Debug with externalTerminal",
    program = "${file}",
    request = "launch",
    type = "python"
}

local dap_grocery_shopper = {
    console = 'externalTerminal',
    name = "Debug grocery_shopper with '-n 2'",
    -- needs absolute path
    program = vim.fn.expand '~/programmieren/grocery-shopper/grocery_shopper/start.py',
    request = "launch",
    type = "python",
    cwd = vim.fn.expand '~/programmieren/grocery-shopper/',
    args = { '-n', '2' }
}

local dap_grocery_shopper_custom_args = {
    console = 'externalTerminal',
    name = "Debug grocery_shopper with custom Arguments",
    program = vim.fn.expand '~/programmieren/grocery-shopper/grocery_shopper/start.py',
    request = "launch",
    type = "python",
    cwd = vim.fn.expand '~/programmieren/grocery-shopper/',
    args = function()
        local cli_args = vim.fn.input 'Debug with Arguments: '
        local cli_args_table = {}
        for token in cli_args:gmatch("%S+") do
            table.insert(cli_args_table, token)
        end
        return cli_args_table
    end,
}

-- Not useable for complex issues like starting Neovim in subprocess
local dap_py_inTerm = {
    console = 'integratedTerminal',
    name = "Debug with integratedTerminal",
    program = "${file}",
    request = "launch",
    type = "python"
}

local dap_py_default = {
    name = "Debug file (default config without 'console')",
    program = '${file}',
    request = "launch",
    type = "python",
    -- justMyCode = false
}
-- Make configuration avialable, ie. entry for menu after `h dap.continue()` was called
dap.configurations.python = {
    dap_py_default,
    dap_py_exTerm,
    dap_pytest_config,
    dap_py_inTerm,
    dap_grocery_shopper,
    dap_grocery_shopper_custom_args,
}


-- To be used in keymaps to start config directly, s. dap.lua
-- TODO: Doesn't work but I want to be prepared <28-01-2024>
-- local M = {}
--
-- M.dap_pytest_config = dap_pytest_config
-- M.dap_py_in_term = dap_py_ex_term
-- M.dap_py_in_term = dap_py_in_term
--
-- return M
--
--
