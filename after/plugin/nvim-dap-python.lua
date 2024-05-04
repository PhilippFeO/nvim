local dap_python = require('dap-python')
-- setup according to https://github.com/mfussenegger/nvim-dap-python
-- The debugger will automatically pick-up another virtual environment if it is activated before neovim is started.
-- TODO: Using an environment without debugpy also works. I thought it wouldn't. <26-026-01-2024
-- dap_python.setup(vim.fn.expand(os.getenv('VIRTUAL_ENV')))

dap_python.setup(vim.fn.expand('~/.venv/debugpy/bin/python'))

dap_python.test_runner = 'pytest'
