local dap_defaults = {
  request = 'launch',
  type = 'python',
  program = vim.fn.expand('~/programmieren/GPSPos_setzen/src/GPSPos_setzen.py'),
  cwd = vim.fn.expand('~/programmieren/GPSPos_setzen/'),
}


local GPSPos_setzen = vim.tbl_extend(
  'force',
  {
    name = 'GPS Position',
  },
  dap_defaults
)

return {
  configs = {
    GPSPos_setzen,
  },
  test_configs = {}
}
