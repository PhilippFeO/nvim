local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd('BufWritePost', {
  group = augroup('reload-python-dap-configs', { clear = true }),
  -- '/' are mandatory, even on Windows.
  pattern = string.gsub(vim.fn.stdpath('config'), '\\', '/') .. '/lua/dap-configs/*.lua',
  callback = function(event)
    require('dap').configurations.python = require('dap-configs.load_python_configs').gather_dap_python_configs()
  end,
  desc = 'Reload Python DAP Configs after editing a config.',
})

autocmd('BufWritePost', {
  group = augroup('reload-python-dap-configs', { clear = true }),
  pattern = '*.py',
  callback = function(event)
    require('dap').configurations.python = require('dap-configs.load_python_configs').gather_dap_python_configs()
  end,
  desc = 'Reload Python DAP Configs after saving a python file',
})
