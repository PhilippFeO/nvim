-- ─── Codelldb ──────────
-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
-- https://github.com/vadimcn/codelldb

local dap = require('dap')

dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        -- Mason installs everyting into `stdpath('data')/mason`,
        -- defaults to ~/.local/share/nvim/mason/.
        command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
        args = { "--port", "${port}" },
    }
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            -- TODO: Insert main file/starting point automatically <27-01-2024>
            -- Easy for one file projects but that's not the default.
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}
