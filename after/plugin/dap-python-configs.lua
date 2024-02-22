local dap = require('dap')

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
    -- debugOptions = { 'RedirectOutput' },
}

dap.adapters.my_python_adapter = {
    type = 'executable',
    command = os.getenv('HOME') .. '/.venv/debugpy/bin/python',
    args = { '-m', 'debugpy.adapter' }
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
    command = '/usr/bin/kitty'
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

local dap_py_default = {
    name = "Debug file (default config without 'console')",
    program = vim.fn.expand('~') .. "/proj/cobra-bira/cobra_so2/cml_input.py",
    request = "launch",
    type = "python",
    -- justMyCode = false
}
-- Make configuration avialable, ie. entry for menu after `h dap.continue()` was called
dap.configurations.python = {
    dap_py_default,
    dap_py_ex_term,
    dap_pytest_config,
    dap_py_in_term,
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
