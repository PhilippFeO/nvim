local dap_defaults = {
  request = 'launch',
  type = 'python',
  cwd = vim.fn.expand('~/programmieren/GPSPos_setzen/'),
  args = { 'jpgs/without.jpg' },
}


local flask_set_GPSIFD = vim.tbl_extend(
  'force',
  {
    program = vim.fn.expand('~/programmieren/GPSPos_setzen/src/flask_set_GPSIFD.py'),
    name = 'Set GPSIFD with Flask',
  },
  dap_defaults
)

local file_set_GPSIFD = vim.tbl_extend(
  'force',
  {
    program = vim.fn.expand('~/programmieren/GPSPos_setzen/src/file_set_GPSIFD.py'),
    name = 'Set GPSIFD with File',
  },
  dap_defaults
)

return {
  configs = {
    flask_set_GPSIFD,
    file_set_GPSIFD,
  },
  test_configs = {}
}
