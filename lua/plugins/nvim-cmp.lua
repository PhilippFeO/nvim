-- [[ AUTOCOMPLETION ]]
-- Configuration done in after/plugin/nvim-cmp.lua
return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- !!! Don't forget to add the according sources in ./after/plugin/nvim-cmp.lua !!!
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',     -- Filename/Path completion
    'hrsh7th/cmp-buffer',   -- Completes words from current buffer
    'hrsh7th/cmp-nvim-lua', -- Neovim's Lua API completion
    'hrsh7th/cmp-cmdline',  -- TODO try
  },
}
