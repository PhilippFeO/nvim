local dap_python = require('dap-python')
-- setup according to https://github.com/mfussenegger/nvim-dap-python
-- The debugger will automatically pick-up another virtual environment if it is activated before neovim is started.
-- TODO: Using an environment without debugpy also works. I thought it wouldn't. <26-026-01-2024
-- dap_python.setup(vim.fn.expand('$VIRTUAL_ENV'))
--
-- dap.continue does not work, test_method() does
dap_python.setup('~/.venv/debugpy/bin/python')

dap_python.test_runner = 'pytest'
