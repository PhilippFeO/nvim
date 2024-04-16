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

-- ~/.cache/nvim/cache
require('dap').set_log_level('TRACE')

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
        -- cmd = {
        --     '--compile-commands-dir=/localhome/rost_ph/proj/upas-l2/UPAS-L2/'
        -- }
    },
    {
        name = "Launch S5p-UPAS with SO2, Across-Track",
        type = "cppdbg",
        request = "launch",
        program = vim.fn.expand('~/proj/upas-s5p/UPAS-L2/build/verbose/upas-l2'),
        args = {
            '--so2',
            vim.fn.expand(
                '~/proj/upas-s5p/UPAS-L2/build/netCDF_startfiles/S5P_OFFL_L1B_IR_UVN_20240315T062230_20240315T080401_33268_03_020100_20240315T095524.nc'),
            vim.fn.expand(
                '~/proj/upas-s5p/UPAS-L2/build/netCDF_startfiles/S5P_OFFL_L1B_RA_BD3_20240315T094531_20240315T112702_33270_03_020100_20240315T131648.nc'),
            '-b',
            '2000',
            '-n',
            '10',
            '-t',
            '1', -- Sequentiell
            '--alongtrack',
            '--aux-cloud $(find . -name "*L2__CLOUD*.nc" | sort -n | tail -n 1)',
            '--aux-o3 $(find . -name "*L2__O3*.nc" | sort -n | tail -n 1)',
        },
        --[[
./upas-l2
 --so2 /home/sentinel5p-data/archive/L1B/2024/03/15/irradiance/OFFL/S5P_OFFL_L1B_IR_UVN_20240315T062230_20240315T080401_33268_03_020100_20240315T095524.nc /home/sentinel5p-data/archive/L1B/2024/03/15/33270/OFFL/S5P_OFFL_L1B_RA_BD3_20240315T094531_20240315T112702_33270_03_020100_20240315T131648.nc
 -b 2000
 -n 10
 -t 12
 --alongtrack
 --aux-cloud $(find . -name "*L2__CLOUD*.nc" | sort -n | tail -n 1)
 --aux-o3 $(find . -name "*L2__O3*.nc" | sort -n | tail -n 1)`
--]]
        cwd = vim.fn.expand('~/proj/upas-s5p/UPAS-L2/build/verbose/'),
        stopAtEntry = true,
        -- externalConsole = true,
        -- gdb pretty printing
        setupCommands = {
            {
                text = '-enable-pretty-printing',
                description = 'enable pretty printing',
                ignoreFailures = false
            },
        },
        -- cmd = {
        --     '--compile-commands-dir=/localhome/rost_ph/proj/upas-l2/UPAS-L2/build'
        -- }
    }
}
