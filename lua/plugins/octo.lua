-- https://github.com/pwntester/octo.nvim
return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'Octo',
  opts = {
    enable_builtin = true,
    users = "mentionable",
  },
  keys = {
    -- { '<Leader>o', '<Cmd>Octo<CR>', desc = 'Octo: [o]cto-Befehlsübersicht' }
    { '<Leader>iu', '<Cmd>Octo issue url<CR>', desc = 'Octo: [i]ssue [u]rl' },
  },
  enabled = true,
  -- cond = vim.fn.executable('gh') == 1, -- 2026-05-09: `gh` not available on Windows
}
