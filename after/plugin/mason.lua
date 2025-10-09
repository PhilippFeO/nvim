require('mason').setup()

-- Has to be loaded **after** Mason, ie. `require('mason').setup()`
-- TODO: README und Doku durchlesen <25-01-2024>
require('mason-nvim-dap').setup {
  -- Makes a best effort to setup the various debuggers with
  -- reasonable debug configurations
  automatic_setup = true,
  ensure_installed = {
    'debugpy', -- s. https://github.com/mfussenegger/nvim-dap-python
    'bash-debug-adapter',
    'shellcheck',
  },
}

-- Ensure the servers above are installed
require 'mason-lspconfig'.setup {
  automatic_enable = true,
  ensure_installed = {
    'basedpyright',
    'pylsp',
    'ruff',
    'bashls',
    'lua_ls',
    'texlab',
    -- Doesn't work, dont know why
    -- 'djlsp',
    -- DAP servers, so not suited for Mason
    -- 'debugpy',
    -- 'shellcheck',
    -- 'bash-debug-adapter',
  }
}

-- local on_attach = require 'lsp-keymaps' -- lua/lsp-keymaps.lua
