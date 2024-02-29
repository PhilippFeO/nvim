-- Setup mason so it can manage external tooling
require('mason').setup()

-- Has to be loaded **after** Mason, ie. `require('mason').setup()`
-- TODO: Change symbols of Breakpoint and conditional Breakpoint <25-01-2024
-- `h sign_define()` vllt hilfreich
-- Config von https://youtu.be/RziPWdTzSV8?t=539 vllt. hilfreich (schauen, wo er das definierte Zeichen verwendet)
-- TODO: README und Doku durchlesen <25-01-2024>
require('mason-nvim-dap').setup {
  -- Makes a best effort to setup the various debuggers with
  -- reasonable debug configurations
  automatic_setup = true,

  -- You'll need to check that you have the required things installed
  -- online, please don't ask me how to install them :)
  ensure_installed = {
    -- DAP
    'debugpy', -- s. https://github.com/mfussenegger/nvim-dap-python
    -- LSP
    'lua-language-server',
    'python-lsp-server',
  },
}

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
-- Extends completion features, s. https://github.com/hrsh7th/cmp-nvim-lsp
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

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    -- Use a sharp border with `FloatBorder` highlights
    border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, -- chars from kanagawa.nvim
    -- add the title in hover float window
    -- title = "hover"
  }
)

-- ─── Python ──────────
-- Pylsp needs it's own setup process. I don't know why.
-- TODO: Bei mason-Entwickler nachfragen <03-12-2023>
require 'lspconfig'.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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

-- ─── C++ ──────────
require 'lspconfig'.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  -- cmd = {
  --   vim.fn.expand('~/.local/share/nvim/mason/bin/clangd'),
  --   '--compile-commands-dir=/localhome/rost_ph/proj/upas-l2/UPAS-L2/'
  -- }
}
