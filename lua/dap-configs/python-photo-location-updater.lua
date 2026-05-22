local dap_defaults = {
  request = 'launch',
  type = 'python',
}

local photo_location_updater = vim.tbl_extend(
  'force',
  {
    program = vim.fn.expand('main.py'),
    name = 'photo-location-updater',
    args = { '--folder', vim.fn.expand('jpgs/'), },
  },
  dap_defaults
)

return {
  configs = {
    photo_location_updater
  }
}
