--  The configuration is done in after/plugin/lsp.lua
return {
  'neovim/nvim-lspconfig', -- LSP Configuration
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',

    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim', -- GitHub: Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
  },
}
