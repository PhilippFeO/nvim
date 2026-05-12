-- https://github.com/pwntester/octo.nvim
return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require 'octo'.setup({
      enable_builtin = true,
      users = "mentionable",
    })
  end,
  keys = {
    -- { '<Leader>o', '<Cmd>Octo<CR>', desc = 'Octo: [o]cto-Befehlsübersicht' }
    { '<Leader>iu', '<Cmd>Octo issue url<CR>', desc = 'Octo: [i]ssue [u]rl' },
  },
  cond = not ON_WINDOWS, -- 2026-05-09: `gh` missing on Windows
}
