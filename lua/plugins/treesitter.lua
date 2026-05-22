return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
  },
  lazy = false,
  build = ':TSUpdate',
  -- Repo is archived.
  --  'main' targets Neovim 0.12
  --  'master' targets Neovim 0.11
  branch = 'main',
}
