-- Setup mason so it can manage external tooling
require('mason').setup()

-- contaings keymaps
local on_attach = require('lsp-keymaps') -- lua/lsp-keymaps.lua

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { 'vim' } }, -- Get the language server to recognize the `vim` global
    }
  },
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

-- copied from after/plugin/nvim-cmp.lua
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
-- print(vim.inspect(capabilities))

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}


-- Muss als letztes stehen, sonst wird die Funktion nicht ausgeführt
-- require 'lspconfig'.pylsp.setup {
--   on_attach = function()
--     -- TODO: Kanagawa für Floating Windows besser konfigurieren (Rahmen, andere Farbe, etc) <25-11-2023>
--     vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
--     vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
--       buffer = 0,
--       desc = {
--         "[g]o to [d]efinition (as in plain vim)"
--       }
--     })
-- Not inherently LSP specific, because `vim.diagnostic` ist used and not `vim.lsp` but LSP provides the diagnostics
-- vim.keymap.set("n", "<Leader>dj", vim.diagnostic.goto_next, {
--   buffer = 0,
--   desc = {
--     "next [d]iagnositc [j] (vim motion)"
--   }
-- })
-- vim.keymap.set("n", "<Leader>dk", vim.diagnostic.goto_prev, {
--   buffer = 0,
--   desc = {
--     "previous [d]iagnositc [k] (vim motion)"
--   }
-- })
--     -- Opens a buffer for every file containing the identifier, ie. ":wa" necessary, although one file was opened originally
--     vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, {
--       buffer = 0,
--       desc = {
--         "[r]ename identifier"
--       }
--     })
--     -- <Leader>r vim.lsp.buf.rename
--     --    Ändert Erscheinung auch in anderen Dateien
--     --    Man muss ggfl. manchmal :wa ausführen, wenn andere Buffer, in denen etwas geändert wurde, geöffnet wurde
--     --        vllt mit ":wa" kombinieren
--
--     -- Funktioniert in Python nicht aber in Go
--     -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {
--     --   buffer = 0,
--     --   desc = {
--     --     "[g]o to [i]mplementation"
--     --   }
--     -- })
--     -- Funktioniert in Python nicht aber in Go
--     -- vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, {
--     --   buffer = 0,
--     --   desc = {
--     --     "[g]o [t]o [t]ype definition"
--     --   }
--     -- })
-- end,
--   settings = {
--     pylsp = {
--       plugins = {
--         pycodestyle = {
--           maxLineLength = 100
--         }
--       }
--     }
--   }
-- }
