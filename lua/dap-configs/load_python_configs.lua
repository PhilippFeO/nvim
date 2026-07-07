--- @alias DAPConfig table<string, string>
--- @return table<DAPConfig>
local function gather_dap_python_configs()
  -- `require` caches modules after the first load, so without clearing these
  -- here, editing e.g. python-work.lua and reloading would keep returning the
  -- stale, cached configs instead of picking up the file's new contents.
  for name, _ in pairs(package.loaded) do
    if name:match('^dap%-configs%.python') then
      package.loaded[name] = nil
    end
  end

  local my_configs = {
    require 'dap-configs.python-default'.configs,
    require 'dap-configs.python-kursverwaltung'.configs,
    require 'dap-configs.python-work'.configs,
    require 'dap-configs.python-tagebuch'.configs,
    require 'dap-configs.python-tagebuch'.test_configs,
  }
  local all_configs = {}
  for _, list in ipairs(my_configs) do
    for _, value in ipairs(list) do
      table.insert(all_configs, value)
    end
  end

  return all_configs
end

-- Configs installed into `dap.configurations.python` by the most recent call
-- to `refresh_dap_python_configs`. Tracked so a later refresh can remove
-- exactly these before inserting the freshly gathered ones, without
-- clobbering configs added by other sources (e.g. nvim-dap-python's own
-- default configs, appended after this module runs at startup).
local last_injected_configs = {}

--- Gathers the python DAP configs and (re-)installs them into
--- `require('dap').configurations.python`, replacing only the configs a
--- previous call installed.
--- @return table<DAPConfig>
local function refresh_dap_python_configs()
  local my_configs = gather_dap_python_configs()

  local dap_configurations = require('dap').configurations
  local kept = vim.tbl_filter(
    function(config)
      return not vim.tbl_contains(last_injected_configs, config)
    end,
    dap_configurations.python or {}
  )

  vim.list_extend(kept, my_configs)
  dap_configurations.python = kept
  last_injected_configs = my_configs

  return my_configs
end

return {
  gather_dap_python_configs = gather_dap_python_configs,
  refresh_dap_python_configs = refresh_dap_python_configs,
}
