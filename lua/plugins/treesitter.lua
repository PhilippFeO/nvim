return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
  },
  -- config = function()
  --   pcall(require('nvim-treesitter.install').update { with_sync = true })
  -- end,
  -- lazy = false,
  -- build = ':TSUpdate',
  -- Archived
  -- main: 0.12
  -- master: 0.11
  -- branch = 'main' and vim.fn.has('nvim-0.12') or 'master',
}
