-- local import_jinja = vim.tbl_extend(
--   'force',
--   {
--     name = name_stump .. ' --import-jinja',
--     module = module_stump .. '.import_jinja',
--     args = {
--       '2026-06-07',
--     }
--   },
--   dap_defaults
-- )

---Helper function to build DAP configs
---@param cli_args table<string> Name of the Python unit test module (including extension)
---@param module_name string If config shall run a pytest unit test module
---@return table
local function build_dap_config(module_name, cli_args)
  return {
    type = 'python',
    request = 'launch',
    name = module_name .. ' ' .. table.concat(cli_args, ' '),
    module = module_name,
    args = cli_args,
  }
end

local import_html = build_dap_config('tagebuch',
  { '--import-html', vim.fn.expand '~/programmieren/tagebuch/2025/2025-02-15/' })
local import_photos = build_dap_config('tagebuch', { '--import-photos' })
local import_tree = build_dap_config('tagebuch',
  { '--import-tree', vim.fn.expand '~/programmieren/tagebuch/2025/' })
local get_DATE = build_dap_config('tagebuch', { '--get', '2026-07-04', })
local delete_DATE = build_dap_config('tagebuch', { '--delete', '11-01-2025', })

-- ─── Pytest Configs ──────────

local import_jinja_test = build_dap_config('pytest', { '-rA', 'tests/', 'test_import_jinja.py' })
local import_html_test = build_dap_config('pytest', { '-rA', 'tests/test_import_html.py' })
local import_photos_test = build_dap_config('pytest', { '-rA', 'tests/', 'test_import_photos.py' })

-- ────────────────────────────────────────

return {
  configs = {
    import_tree,
    import_photos,
    import_html,
    get_DATE,
    delete_DATE,
  },
  -- Necessary as key-value-pair for keymap for test_method (2025-09-12: <Leader>dm)
  test_configs = {
    import_jinja_test,
    import_html_test,
    import_photos_test,
  },
}
