-- Debugpy configurations:
-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings

-- This enables debugging Tests in the first place.
-- More information in my Wiki
local pytest_default_config = {
    name = "Pytest: Current File",
    type = "python",
    request = "launch", -- or 'attach' TODO: What does attach? <27-01-2024>
    module = "pytest",
    -- TODO: Define args via `pytest.ini`. <27-01-2024>
    args = {
        -- "${file}",
        "-rA",
        "-sv",
        -- "--log-cli-level=INFO",
        -- "--log-file=test_out.log"
    },
    -- integratedTerminal: Terminal in split next to Code; doesn't close on dap.disconnect()
    -- externalTerminal: own terminal window for output
    -- internalConsole: print output in dap-repl window (default)
    -- console = "internalConsole",
    -- If true and console = 'externalTerminal', then output is printed in 'externalTerminal' only
    -- If false, then no ouput is printed
    redirectOutput = true,
    -- Display return value of function in DAP Scopes window
    showReturnValue = false,
    -- justMyCode = true,
}

local default_external_terminal = {
    console = 'externalTerminal',
    name = "Debug with externalTerminal",
    program = "${file}",
    request = "launch",
    type = "python"
}

-- Not useable for complex issues like starting Neovim in subprocess
local default_integrated_terminal = {
    console = 'integratedTerminal',
    name = "Debug with integratedTerminal",
    program = "${file}",
    request = "launch",
    type = "python"
}

local default_internal_console = {
    console = 'internalConsole',
    name = "Debug with internalConsole",
    program = "${file}",
    request = "launch",
    type = "python",
}

local default_no_console_foreign_code = {
    name = "Debug file (default config without 'console' + justmyCode=false)",
    program = '${file}',
    request = "launch",
    type = "python",
    justMyCode = false,
}

local grocery_shopper = {
    console = 'externalTerminal',
    name = "Debug grocery_shopper with '-n 2'",
    program = './grocery_shopper/start.py',
    request = "launch",
    type = "python",
    -- necessary, doesn't use PWD automatically
    cwd = vim.fn.expand '~/programmieren/grocery-shopper',
    args = { '-n', '2' }
}

local grocery_shopper_custom_args = {
    console = 'externalTerminal',
    name = "Debug grocery_shopper with custom Arguments",
    program = vim.fn.expand '~/programmieren/grocery-shopper/grocery_shopper/start.py',
    request = "launch",
    type = "python",
    cwd = vim.fn.expand '~/programmieren/grocery_shopper',
    args = function()
        local cli_args = vim.fn.input 'Debug with Arguments: '
        local cli_args_table = {}
        for token in cli_args:gmatch("%S+") do
            table.insert(cli_args_table, token)
        end
        return cli_args_table
    end,
}

local grocery_shopper_pdf = {
    console = 'externalTerminal',
    name = "Debug grocery_shopper with '--pdf Spätzle.yaml'",
    -- needs absolute path
    program = vim.fn.expand '~/programmieren/grocery-shopper/grocery_shopper/start.py',
    request = "launch",
    type = "python",
    cwd = vim.fn.expand '~/programmieren/grocery_shopper',
    args = { '--pdf', 'Spätzle.yaml' }
}


return {
    configs = {
        default_external_terminal,
        default_integrated_terminal,
        default_internal_console,
        default_no_console_foreign_code,
        -- pytest_default_config,
        grocery_shopper,
        grocery_shopper_custom_args,
        grocery_shopper_pdf,
        -- diary,
        -- For use in keymap <Leader>dm for `test_method()`
        -- pytest_default_config = pytest_default_config,
    },
    -- Used in Keymap <Leader>dm in after/plugin/dap-keymaps.lua for debugging single test method
    test_configs = {
        pytest_default_config = pytest_default_config,
    }
}
