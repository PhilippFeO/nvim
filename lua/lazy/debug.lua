return {
  'mfussenegger/nvim-dap',

  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- TODO: GitHub-Seite konsultieren <13-03-2023> --
    'mfussenegger/nvim-dap-python',

    'theHamsta/nvim-dap-virtual-text',
    'nvim-telescope/telescope-dap.nvim',
  },
}
