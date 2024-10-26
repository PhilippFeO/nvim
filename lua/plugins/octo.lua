-- https://github.com/pwntester/octo.nvim
return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    -- OR 'ibhagwan/fzf-lua',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require 'octo'.setup({ enable_builtin = true })
  end,
  keys = {
    -- { '<Leader>o', '<Cmd>Octo<CR>', desc = 'Octo: [o]cto-Befehlsübersicht' }
    { '<Leader>iu', '<Cmd>Octo issue url<CR>', desc = 'Octo: [i]ssue [u]rl' },
  }
}
