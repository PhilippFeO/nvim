-- [[ LSP related plugins ]]
--  The configuration is done in after/plugin/lsp.lua
return  {
  'neovim/nvim-lspconfig', -- LSP Configuration
  dependencies = {
    -- Mason to manage LSP servers with ease
    -- Automatically install LSPs to stdpath for neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
}
