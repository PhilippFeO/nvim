-- Setup mason so it can manage external tooling
require('mason').setup()

-- contains keymaps
local on_attach = require('lsp-keymaps') -- lua/lsp-keymaps.lua

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--> Check output of :LspInfo (maybe using <Tab> afterwards) for useful information!
local servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { 'vim' } }, -- Get the language server to recognize the `vim` global
    }
  },
  -- Doesn't work here, I dont't know why. See below.
  -- pylsp = {
  --   plugins = {
  --     pycodestyle = {
  --       maxLineLength = 10
  --     }
  --   }
  -- }
}


-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- copied from after/plugin/nvim-cmp.lua, because `capabilities` was flagged unknown by LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup LSP servers specified in `servers` list above
mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}


-- Pylsp needs it's own setup process. I don't know why.
-- TODO: Bei mason-Entwickler nachfragen <03-12-2023>
require 'lspconfig'.pylsp.setup {
  on_attach = on_attach,
  -- on_attach = function()
  --   -- TODO: Kanagawa für Floating Windows besser konfigurieren (Rahmen, andere Farbe, etc) <25-11-2023>
  --   -- Not inherently LSP specific, because `vim.diagnostic` ist used and not `vim.lsp` but LSP provides the diagnostics (I guess)
  --   vim.keymap.set("n", "<Leader>dj", vim.diagnostic.goto_next, {
  --     buffer = 0,
  --     desc = {
  --       "next [d]iagnositc [j] (vim motion)"
  --     }
  --   })
  --   vim.keymap.set("n", "<Leader>dk", vim.diagnostic.goto_prev, {
  --     buffer = 0,
  --     desc = {
  --       "previous [d]iagnositc [k] (vim motion)"
  --     }
  --   })
  -- end,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          maxLineLength = 150
        }
      }
    }
  }
}


vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    -- Use a sharp border with `FloatBorder` highlights
    border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, -- chars from kanagawa.nvim
    -- add the title in hover float window
    -- title = "hover"
  }
)


-- ────────────────────────────────────────

-- TODO: README and docs <25-01-2024>
-- Displays variable names next to their definition, uses TreeSitter to find the respective location
require 'nvim-dap-virtual-text'.setup()


local dap = require 'dap'
local dapui = require 'dapui'

-- TODO: Change symbols of Breakpoint and conditional Breakpoint <25-01-2024

-- TODO: README und Doku durchlesen <25-01-2024>
require('mason-nvim-dap').setup {
  -- Makes a best effort to setup the various debuggers with
  -- reasonable debug configurations
  automatic_setup = true,

  -- You'll need to check that you have the required things installed
  -- online, please don't ask me how to install them :)
  ensure_installed = {
    'debugpy', -- s. https://github.com/mfussenegger/nvim-dap-python
  },
}

-- Basic debugging keymaps, feel free to change to your liking!
-- TODO: Log point message, fi. Breakpoint was hit <25-01-2024>
local nmap = function(keys, func, desc)
  if desc then
    desc = ' DAP: ' .. desc
  end

  vim.keymap.set('n', keys, func, { desc = desc })
end
nmap('<F5>', dap.continue) --Entry point for all Debugger things
nmap('<F1>', dap.step_into, '  Step into')
nmap('<F2>', dap.step_over, '  Step over')
nmap('<F3>', dap.step_out, '  Step out')
nmap('<leader>b', dap.toggle_breakpoint, '  Toggle Breakpoint')
nmap('<leader>B', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, '  Toggle Conditional Breakpoint')
nmap('<Leader>dc', dap.terminate, '󰗼  Terminate Debugging')

-- TODO: `h nvim-dap-ui` <25-01-2024>
-- Here you fi control the panes, s. https://youtu.be/0moS8UHupGc?t=1481
dapui.setup {
  -- Set icons to characters that are more likely to work in every terminal.
  -- TODO: Highlight Groups dieser ändern, Highlightgroups sollte es in `h nvim-dap-ui` geben
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      -- nerdfonts: search for 'debug_'
      pause = '󰏤',
      play = '▶',
      step_into = '',
      step_over = ' ',
      step_out = '', -- 󰆸
      step_back = ' ',
      run_last = '▶▶',
      terminate = 't ',
    },
  },
}

-- Open dapui automagically
-- Scheme: Event -> run function
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- setup according to https://github.com/mfussenegger/nvim-dap-python
require('dap-python').setup('~/.venv/debugpy/bin/python')
