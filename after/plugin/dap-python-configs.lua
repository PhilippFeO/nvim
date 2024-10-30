-- Debugpy configurations:
-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings


-- bdelete! *dap-terminal* schließt integratedTerminal
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
    if DLR_Machine then
        return vim.fn.expand('/usr/bin/kitty')
    else
        return vim.fn.expand('~/.local/bin/kitty')
    end
end
dap.defaults.fallback.external_terminal = {
    command = command()
}
-- dap.defaults.fallback.force_external_terminal = true


-- ─── Configurations ──────────

-- This enables debugging Tests in the first place.
-- More information in my Wiki
local pytest_default_config = {
    name = "Pytest: Current File",
    type = "python",
    request = "launch", -- or 'attach' TODO: What does attach? <27-01-2024>
    module = "pytest",
    -- TODO: Define args via `pytest.ini`. <27-01-2024>
    args = {
        "${file}",
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

local grocery_shopper = {
    console = 'externalTerminal',
    name = "Debug grocery_shopper with '-n 2'",
    -- needs absolute path
    program = DLR_Machine and vim.fn.expand '~/proj/grocery-shopper/grocery_shopper/start.py' or
        vim.fn.expand '~/programmieren/grocery-shopper/grocery_shopper/start.py',
    request = "launch",
    type = "python",
    cwd = DLR_Machine and vim.fn.expand '~/proj/grocery-shopper/' or vim.fn.expand '~/programmieren/grocery_shopper',
    args = { '-n', '2' }
}

local grocery_shopper_custom_args = {
    console = 'externalTerminal',
    name = "Debug grocery_shopper with custom Arguments",
    program = DLR_Machine and vim.fn.expand '~/proj/grocery-shopper/grocery_shopper/start.py' or
        vim.fn.expand '~/programmieren/grocery-shopper/grocery_shopper/start.py',
    request = "launch",
    type = "python",
    cwd = DLR_Machine and vim.fn.expand '~/proj/grocery-shopper/' or vim.fn.expand '~/programmieren/grocery_shopper',
    args = function()
        local cli_args = vim.fn.input 'Debug with Arguments: '
        local cli_args_table = {}
        for token in cli_args:gmatch("%S+") do
            table.insert(cli_args_table, token)
        end
        return cli_args_table
    end,
}

local diary_Lindau = {
    name = 'Tagebuch: Lindau',
    request = 'launch',
    type = 'python',
    program = vim.fn.expand '~/.tagebuch/my_html_handler.py',
    cwd = vim.fn.expand '~/.tagebuch',
    args = { vim.fn.expand '~/.tagebuch/2024/06-Juni/05-06-2024-Mittwoch-Lindau/05-06-2024-Mittwoch-Lindau.html' },
}



-- Work configs
-- ────────────
local TDS_creation = {
    name = 'Create TDS',
    request = 'launch',
    type = 'python',
    program = vim.fn.expand '~/proj/l2op/formatter_tools/createTDS.py',
    args = { '--config_file', 'cfg/config_TDS_0.13.ini' }
}

local l1formatter_tds012 = {
    name = 'L1-Formatter TDS 0.12',
    request = 'launch',
    type = 'python',
    program = vim.fn.expand '~/proj/l2op/formatter_tools/L1b_formatter/tool_src/GeneratorL1b.py',
    cwd = vim.fn.expand '~/proj/l2op/formatter_tools/L1b_formatter/tool_src',
    args = {
        '-i',
        './TDS_0.12/01/lv1__ECA2____01_20030624_SN__0.12.nc',
        './TDS_0.12/02/lv1__ECA2____02_20030624_SN__0.12.nc',
        './TDS_0.12/03/lv1__ECA2____03_20030624_SN__0.12.nc',
        -- './TDS_0.12/04/lv1__ECA2____04_20030624_SN__0.12.nc',
        -- './TDS_0.12/05/lv1__ECA2____05_20030624_SN__0.12.nc',
        -- './TDS_0.12/06/lv1__ECA2____06_20030624_SN__0.12.nc',
        -- './TDS_0.12/07/lv1__ECA2____07_20030624_SN__0.12.nc',
        -- './TDS_0.12/08/lv1__ECA2____08_20030624_SN__0.12.nc',
        -- './TDS_0.12/09/lv1__ECA2____09_20030624_SN__0.12.nc',
        -- './TDS_0.12/10/lv1__ECA2____10_20030624_SN__0.12.nc',
        -- './TDS_0.12/11/lv1__ECA2____11_20030624_SN__0.12.nc',
        -- './TDS_0.12/12/lv1__ECA2____12_20030624_SN__0.12.nc',
        -- './TDS_0.12/13/lv1__ECA2____13_20030624_SN__0.12.nc',
        -- './TDS_0.12/14/lv1__ECA2____14_20030624_SN__0.12.nc',
        -- './TDS_0.12/15/lv1__ECA2____15_20030624_SN__0.12.nc',
        -- './TDS_0.12/16/lv1__ECA2____16_20030624_SN__0.12.nc',
        -- './TDS_0.12/17/lv1__ECA2____17_20030624_SN__0.12.nc',
        '-t', '4',
        '-o', 'output/',
    },
}

local l1formatter_tds013 = {
    -- a to have it in front of the other L1-Formatter config
    name = 'L1-Formatter TDS 0.13',
    request = 'launch',
    type = 'python',
    program = vim.fn.expand '~/proj/l2op/formatter_tools/L1b_formatter/tool_src/GeneratorL1b.py',
    cwd = vim.fn.expand '~/proj/l2op/formatter_tools/L1b_formatter/tool_src',
    args = {
        '-i',
        './TDS_0.13/data/detector_orientation_from_South_to_North/clearsky_fullycloudy/01/lv1__ECA2____01_20030620_SN__0.13.nc',
        './TDS_0.13/data/detector_orientation_from_South_to_North/clearsky_fullycloudy/02/lv1__ECA2____02_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____04_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____05_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____06_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____07_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____08_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____09_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____10_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____11_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____12_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____13_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____14_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____15_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____16_20030620_SN__0.13.nc',
        -- './TDS_0.13/data/detector_orientation_from_South_to_North/broken_cloud/lv1__ECA2____17_20030620_SN__0.13.nc',
        '-t', '4',
        '-o', 'output/',
    },
}
-- Not useable for complex issues like starting Neovim in subprocess
local default_integrated_terminal = {
    console = 'integratedTerminal',
    name = "Debug with integratedTerminal",
    program = "${file}",
    request = "launch",
    type = "python"
}

local default_no_console = {
    name = "Debug file (default config without 'console')",
    program = '${file}',
    request = "launch",
    type = "python",
    -- justMyCode = false
}

-- https://code.visualstudio.com/docs/python/tutorial-django
-- https://stackoverflow.com/questions/62944425/how-to-debug-django-in-vscode-with-autoreload-turned-on
local django = {
    name = "Django Debugger",
    type = "debugpy",
    request = "launch",
    program = "${workspaceFolder}/manage.py",
    args = { "runserver", "--settings=kursverwaltung.settings_dev" },
    env = {
        EMAIL_HOST_USER = 'lorem@ipsum.de',
        SECRET_KEY = 'django-insecure-ivvcj*%d@qhm1&#e&rez)ot35prmz$d@-bg6mbpd*m*i281ax)',
        -- DEBUG = true,
    },
    django = true,
    justMyCode = true,
}

-- Make configuration avialable, ie. entry for menu after `h dap.continue()` was called
dap.configurations.python = {
    default_no_console,
    default_external_terminal,
    default_integrated_terminal,
    pytest_default_config,
    grocery_shopper,
    grocery_shopper_custom_args,
    diary_Lindau,
    django,
    l1formatter_tds012,
    l1formatter_tds013,
    TDS_creation,
}

-- Used in Keymap <Leader>dm in after/plugin/dap-keymaps.lua for debugging single test method
local M = {
    pytest_default_config = pytest_default_config,
}
return M
