--[[

READ: `h dap.set_exception_breakpoints()`!
Maybe useful if debugging session directly terminates in case of an exception in the python code

--]]


local dap = require 'dap'
local telescope = require 'telescope'
local dap_view = require 'dap-view'
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
  -- Maybe toggle() is also useful
  dap_view.close()
end, '󰗼  Terminate Debugging')

nmap('<Leader>dl', function()
  vim.cmd('cclose')
  -- To run the most recent changes and with presumably edited Config
  -- (DAP configs are sourced on `BufWritePost`)
  vim.cmd('write')
  dap.run_last()
end, '[d]ebug with [l]ast configuration')

nmap('<Leader>dm', function()
  require 'dap-python'.test_method({
    -- necessary, if 'console' not explicitly set in config
    console = 'internalConsole',
    test_runner = 'pytest',
    -- ! Don't forget to add the respective config in the returned table
    -- config = require 'dap-configs.python'.test_configs.pytest_default_config,
    config = require 'dap-configs.python-kursverwaltung'.test_configs.kursverwaltung_docker_unittest,
  })
end, '[d]ebug single [m]ethod')

nmap('<Leader>dx', dap.set_exception_breakpoints, 'Set [d]ap e[x]ception breakpoint')

nmap('<Leader>dv', '<Cmd>DapVirtualTextToggle<CR>', 'toggle [d]ap [v]irtual text')


-- Dapui-Keymaps
-- ─────────────
local dapui = require 'dapui'

nmap('<Leader>dr', function()
  dapui.open({ reset = true })
end, '[d]apui [r]eset GUI')
nmap('<Leader>du', dapui.toggle, '[d]ap[u]i toggle')
nmap('<Leader>dw', function()
  local bufnr = vim.fn.bufnr('DAP Watches')
  -- All windows holding the buffer
  -- Almost certainly, there is only one window
  local winnr = vim.fn.win_findbuf(bufnr)
  vim.fn.win_gotoid(winnr[1])
end, 'Goto [d]ap [w]atches')


-- Dapview-Keymaps
-- ────────────────

nmap('<Leader>ae', function(expr)
  dap_view.add_expr(expr)
end, '[a]dd [e]xpression under cursor')
nmap('<Leader>jw', function()
  dap_view.jump_to_view 'watches'
end, '[j]ump to [w]atches')
nmap('<Leader>sw', function()
  dap_view.show_view 'watches'
end, '[s]how to [w]atches')

-- Works, even if I don't use the UI provided by dapui
-- vim.keymap.set({ 'v', 'n' }, '<Leader>de', '<Cmd>lua require("dapui").eval()<CR>', {
--   desc = '  DAP: [d]ap [e]val expression',
-- })
vim.keymap.set({ 'v', 'n' }, '<Leader>de', function()
  dapui.eval()
end, {
  desc = '  DAP: [d]ap [e]val expression',
})


-- There is also internal methods to evaluate expression and display them in a floating window:
--  - require('dap.ui.widgets').hover()
--  - The one below
--  - etc.
-- The problem with all of them is, that the cursor enters these windows and I have to quit them manually. With require('dapui').eval() this does not happen and the window vanishes when I move the cursor. Setting up an autocommand on CursorMoved also didn't work because it was triggered every time I type the keys defined below.
-- => I'll go with require('dapui').eval()
--
-- local border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
-- nmap('<Leader>th', function()
--   local widgets = require('dap.ui.widgets')
--   local float_win = widgets.cursor_float(widgets.expression,
--     {
--       border = border,
--       -- focusable = false,
--     })
--   print(vim.inspect(vim.api.nvim_win_get_config(float_win.win)))
-- end)
