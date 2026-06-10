--- @alias DAPConfig table<string, string>

--- @return DAPConfig
local function gather_dap_python_configs()
  local my_configs = {
    require 'dap-configs.python-default'.configs,
    require 'dap-configs.python-kursverwaltung'.configs,
    require 'dap-configs.python-tagebuch'.configs,
    require 'dap-configs.python-set-GPSIFD'.configs,
    require 'dap-configs.python-photo-location-updater'.configs,
  }
  local all_configs = {}
  for _, list in ipairs(my_configs) do
    for _, value in ipairs(list) do
      table.insert(all_configs, value)
    end
  end

  return all_configs
end

return {
  gather_dap_python_configs = gather_dap_python_configs,
}
