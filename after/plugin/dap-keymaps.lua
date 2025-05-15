--[[

READ: `h dap.set_exception_breakpoints()`!
Maybe useful if debugging session directly terminates in case of an exception in the python code

--]]







local dap = require 'dap'
local dapui = require 'dapui'
local telescope = require 'telescope'
local nmap = require 'utils'.nmap('  DAP')

nmap('<F5>', function()
  if vim.o.buftype == '' then
    vim.cmd('write')
  end
  vim.cmd.set('mouse=n')
  -- if a session is active, continue
  if dap.session() then
    -- Make pressing `F5` buffer independent, ie. it works in every window/buffer
    local buffers_in_tab = vim.fn.tabpagebuflist()
    -- Contains buffer numbers of the DAP-UI buffers
    for _, bufnr in ipairs(buffers_in_tab) do
      -- find the one with the python file
      -- => Won't work on other file types
      -- => Probably won't work when multiple python files are open in a split in the same tab
      -- `bufname('.py')` won't work if multiple buffers match this string but I only want buffers from the current tab
      if vim.fn.bufname(bufnr):sub(-3, -1) == '.py' then
        -- find window numbers holding the current buffer. There will (very probably) only one.
        local winnr = vim.fn.win_findbuf(bufnr)
        vim.fn.win_gotoid(winnr[1])
      end
    end
    dap.continue()
    -- else, open configuration picker (and start it)
  else
    telescope.extensions.dap.configurations {}
  end
end, 'Start debugging or continue') --Entry point for all Debugger things

nmap('<F1>', dap.step_into, '  Step into')
nmap('<F2>', dap.step_over, '  Step over')
nmap('<F3>', dap.step_out, '  Step out')
nmap('<F4>', dap.step_back, ' Step out')
nmap('<Leader>do', dap.run_to_cursor, '[d]ap run to curs[o]r')

nmap('<Leader>db', dap.toggle_breakpoint, '  Toggle Breakpoint')
nmap('<Leader>dn', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, '  Toggle Conditional Breakpoint')

nmap('<Leader>dp', function()
  if dap.session() then
    local bufnr = vim.fn.bufnr('DAP Breakpoints')
    -- All windows holding the buffer
    -- Almost certainly, there is only one window
    local winnr = vim.fn.win_findbuf(bufnr)
    vim.fn.win_gotoid(winnr[1])
  else
    dap.list_breakpoints()
    vim.cmd.copen()
  end
end, 'Goto [d]ap [b]reakpoints')

nmap('<Leader>lb', function()
  dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, 'Set [l]ogging [b]reakpoint')

nmap('<Leader>dc', function()
  dap.terminate()
  vim.cmd.set('mouse=')
end, '󰗼  Terminate Debugging')

nmap('<Leader>dl', function()
  vim.cmd('cclose')
  vim.cmd('write')
  dap.run_last()
end, '[d]ebug with [l]ast configuration')

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
vim.keymap.set({ 'v', 'n' }, '<Leader>de', '<Cmd>lua require("dapui").eval()<CR>', {
  desc = '  DAP: [d]ap [e]val expression',
})

nmap('<Leader>dv', '<Cmd>DapVirtualTextToggle<CR>', 'toggle [d]ap [v]irtual text')

nmap('<Leader>dw', function()
  local bufnr = vim.fn.bufnr('DAP Watches')
  -- All windows holding the buffer
  -- Almost certainly, there is only one window
  local winnr = vim.fn.win_findbuf(bufnr)
  vim.fn.win_gotoid(winnr[1])
end, 'Goto [d]ap [w]atches')

nmap('<Leader>dx', dap.set_exception_breakpoints, 'Set [d]ap e[x]ception breakpoint')
