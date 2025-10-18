return {
  'mfussenegger/nvim-dap',

  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio', -- required by nvim-dap-ui

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- TODO: GitHub-Seite konsultieren <13-03-2023> --
    'mfussenegger/nvim-dap-python',

    -- https://github.com/theHamsta/nvim-dap-virtual-text
    'theHamsta/nvim-dap-virtual-text',
    'nvim-telescope/telescope-dap.nvim',

    -- ─── nvim-dap-view ──────────
    {
      "igorlfs/nvim-dap-view",
      ---@module 'dap-view'
      ---@type dapview.Config
      -- Are passed to `require 'dap-view.setup()`
      opts = {
        auto_toggle = true,
        -- sections = { 'watches', 'scopes', 'exceptions', 'breakpoints', 'threads', 'sessions', 'repl' },
        windows = {
          height = 0.3,
          terminal = {
            width = 0.3,
            position = 'right',
          }
        },
        help = {
          border = require('utils').border,
        },
      },
    },
  },
}
