-- https://github.com/pwntester/octo.nvim
return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require 'octo'.setup({ enable_builtin = true })
  end,
  keys = {
    -- { '<Leader>o', '<Cmd>Octo<CR>', desc = 'Octo: [o]cto-Befehlsübersicht' }
    { '<Leader>iu', '<Cmd>Octo issue url<CR>', desc = 'Octo: [i]ssue [u]rl' },
  },
  -- 2026-05-09: `gh` missing on Windows
  -- See also after/plugins/octo.lua: setup() call commented out
  enabled = not IS_WORK_MACHINE,
}
