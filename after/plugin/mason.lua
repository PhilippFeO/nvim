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
    'basedpyright',
    'bash-debug-adapter',
    'bash-language-server',
    'ruff-lsp',
    'shellcheck',
    'texlab',
  },
}

-- contains keymaps
local on_attach = require 'lsp-keymaps' -- lua/lsp-keymaps.lua

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


local lspconfig = require 'lspconfig'

-- ─── Python ──────────
--[[ TODO:  <25-05-2024>
https://www.reddit.com/r/neovim/comments/1bt3dy0/comment/l5813wf/?context=3
basedpyright = {
	settings = {
		basedpyright = {
			typeCheckingMode = "all",
			analysis = {
				diagnosticSeverityOverrides = {
					reportMissingParameterType = false,
					reportUnknownParameterType = false,
				},
			},
		},
	},
},
--]]
lspconfig.basedpyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    basedpyright = {
      -- reportImplicitOverride = false,
      reportMissingSuperCall = "none",
      -- reportUnusedImport = false,
      -- basedpyright very intrusive with errors, this calms it down
      typeCheckingMode = "standard",
    },
    -- Ignore all files for analysis to exclusively use Ruff for linting
    python = {
      analysis = {
        ignore = { '*' },
      },
    },
  }
}

lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pylsp = {
      -- :PyLspInstall <tab>
      plugins = {
        -- Unklar, was es macht, wird ggfl. auch von ruff[-lsp] übernommen
        rope = {
          enabled = false,
        },
        -- All disabled to avoid overlap with ruff-lsp
        -- list from python-lsp-ruff
        pycodestyle = {
          enabled = false,
          maxLineLength = 150
        },
        mccabe = {
          enabled = false,
        },
        pydocstyle = {
          enabled = false,
        },
        -- autopep8, yapf formatieren beide, Unterschied unklar. yapf = false, autopep8 = true macht es so, wie ich es möchte
        yapf = {
          enabled = false,
        },
        autopep8 = {
          enabled = true,
        },
        -- deaktivert pycodestyle, mccabe, autopep8, pydocstyle, yapf, kann man aber wieder aktivieren
        -- 2024-04-18: nicht installiert
        ruff = {
          enabled = false,                                   -- Enable the plugin
          formatEnabled = false,                             -- Enable formatting using ruffs formatter
          config = vim.fn.expand '~/.config/ruff/ruff.toml', -- Custom config for ruff to use
        }
      }
    }
  }
}

-- https://github.com/astral-sh/ruff-lsp
-- Findet ~/.config/ruff/ruff.toml selbstständig
lspconfig.ruff_lsp.setup {
  on_attach = function(client, bufnr)
    -- Disable formatting
    client.server_capabilities.documentFormattingProvider = false
    -- TODO: Herausfinden, wofür dRFP ist <18-04-2024>
    -- client.server_capabilities.documentRangeFormattingProvider = false

    -- local file, err = io.open("/tmp/ruff-caps.txt", "w")
    -- file:write(vim.inspect(client.server_capabilities))

    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}


-- ─── CMAKE ──────────
lspconfig.cmake.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- ─── C++ ──────────
lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  -- doesn't work :(
  -- cmd = {
  --   '/localhome/rost_ph/.local/share/nvim/mason/bin/clangd',
  --   --   '--background-index',
  --   --   '--compile-commands-dir=/localhome/rost_ph/proj/upas-l2/UPAS-L2/src',
  --   '--log=verbose', -- /localhome/rost_ph/.local/state/nvim/lsp.log
  -- }
  --   "--fallback-style='{IndentWidth: 4, ColumnLimit: 70}'",
  -- cmd = { "clangd", "--background-index" }
}
