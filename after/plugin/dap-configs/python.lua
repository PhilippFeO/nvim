local dap = require('dap')


local my_configs = {
  require 'dap-configs.python-default'.configs,
  require 'dap-configs.python-kursverwaltung'.configs,
  require 'dap-configs.python-tagebuch'.configs,
}

local all_configs = {}
for _, list in ipairs(my_configs) do
  for _, value in ipairs(list) do
    table.insert(all_configs, value)
  end
end

-- Make configurations avialable, ie. entry for menu after `h dap.continue()` was called
dap.configurations.python = all_configs
