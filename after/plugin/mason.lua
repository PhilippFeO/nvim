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
          maxLineLength = 100
        }
      }
    }
  }
}
