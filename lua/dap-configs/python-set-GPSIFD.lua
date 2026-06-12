local dap_defaults = {
  request = 'launch',
  type = 'python',
  args = { 'jpgs/without.jpg' },
}

local geocode_photos = vim.tbl_extend(
  'force',
  {
    program = 'geocode.py',
    name = 'Geocode Photos',
  },
  dap_defaults
)

return {
  configs = {
    geocode_photos,
  },
  test_configs = {}
}
