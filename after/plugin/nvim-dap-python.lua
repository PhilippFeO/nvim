local dap_python = require('dap-python')
-- setup according to https://github.com/mfussenegger/nvim-dap-python
-- The debugger will automatically pick-up another virtual environment if it is activated before neovim is started.

-- Either project specific Venv with debugpy installed or ...
-- dap_python.setup(vim.fn.expand(os.getenv('VIRTUAL_ENV') .. '/bin/python3'))

-- debugpy specific Venv, ie. a Venv with only debugpy installed
dap_python.setup(LINUX_OR_WINDOWS(
  vim.fn.stdpath('config') .. '/.venv/debugpy-for-nvim/bin/python',
  vim.fn.stdpath('config') .. '/.venv/debugpy-for-nvim/Scripts/pythonw.exe'
))

dap_python.test_runner = 'pytest'
