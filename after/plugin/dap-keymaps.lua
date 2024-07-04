local dap = require 'dap'
local dapui = require 'dapui'
local nmap = require 'utils'.nmap('  DAP')

nmap('<F5>', function()
  vim.cmd.set('mouse=n')
  dap.continue()
end, 'Start debugging or continue') --Entry point for all Debugger things
nmap('<F1>', dap.step_into, '  Step into')
nmap('<F2>', dap.step_over, '  Step over')
nmap('<F3>', dap.step_out, '  Step out')
nmap('<F4>', dap.step_back, ' Step out')

nmap('<Leader>db', dap.toggle_breakpoint, '  Toggle Breakpoint')
nmap('<Leader>dB', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, '  Toggle Conditional Breakpoint')
nmap('<Leader>lb', function()
  dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, 'Set [l]ogging [b]reakpoint')

nmap('<Leader>dc', function()
  dap.terminate()
  vim.cmd.set('mouse=')
end, '󰗼  Terminate Debugging')
nmap('<Leader>dl', dap.run_last, '[d]ebug with [l]ast configuration')
nmap('<Leader>dm', function()
  require 'dap-python'.test_method({
    -- necessary, if 'console' not explicitly set in config
    console = 'internalConsole',
    test_runner = 'pytest',
    config = require 'dap-python-configs'.pytest_default_config
  })
end, '[d]ebug single [m]ethod')
nmap('<Leader>dr', function()
  dapui.open({ reset = true })
end, '[d]apui [r]eset')
nmap('<Leader>du', dapui.toggle, '[d]ap[u]i toggle')
