-- `h vim.filetype`

if IS_WORK_MACHINE then
  vim.filetype.add({
    extension = {
      -- Consider .pyt files as python files. Plugins/Toolboxes for ArcGIS Pro work with .pyt files.
      pyt = 'python'
    }
  })
end
