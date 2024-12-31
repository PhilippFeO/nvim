return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
  },
  config = function()
    pcall(require('nvim-treesitter.install').update { with_sync = true })
  end,
  -- commit = '7d0b475'
}
