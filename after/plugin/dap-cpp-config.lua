local dap = require('dap')

-- ─── Codelldb ──────────
-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
-- https://github.com/vadimcn/codelldb

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

-- ─── Cpptools ──────────
-- taken from
-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7'
}
-- Additional documenation for the configuration:
-- https://code.visualstudio.com/docs/cpp/launch-json-reference
dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
        externalConsole = true,
        -- gdb pretty printing
        setupCommands = {
            {
                text = '-enable-pretty-printing',
                description = 'enable pretty printing',
                ignoreFailures = false
            },
        },
    },
    -- {
    --     name = 'Attach to gdbserver :1234',
    --     type = 'cppdbg',
    --     request = 'launch',
    --     MIMode = 'gdb',
    --     miDebuggerServerAddress = 'localhost:1234',
    --     miDebuggerPath = '/usr/bin/gdb',
    --     cwd = '${workspaceFolder}',
    --     program = function()
    --         return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    --     end,
    --     -- gdb pretty printing
    --     setupCommands = {
    --         {
    --             text = '-enable-pretty-printing',
    --             description = 'enable pretty printing',
    --             ignoreFailures = false
    --         },
    --     },
    -- },
}
