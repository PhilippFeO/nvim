return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
  },
  config = function()
    pcall(require('nvim-treesitter.install').update { with_sync = true })
  end,
  -- 2025-10-15: master is frozen, development happens on main.
  -- Currently, I don't have the time and motivation to switch since it's a rewrite and my config doesn't work anymore.
  branch = 'master',
  -- commit = '7d0b475'
}
