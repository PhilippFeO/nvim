-- Setup mason so it can manage external toolingmason
require('mason').setup()
local on_attach = require 'lsp-keymaps' -- lua/lsp-keymaps.lua
local mason_lspconfig = require 'mason-lspconfig'

-- Has to be loaded **after** Mason, ie. `require('mason').setup()`
-- TODO: README und Doku durchlesen <25-01-2024>
require('mason-nvim-dap').setup {
	-- Makes a best effort to setup the various debuggers with
	-- reasonable debug configurations
	automatic_setup = true,
	ensure_installed = {
		'debugpy', -- s. https://github.com/mfussenegger/nvim-dap-python
		'bash-debug-adapter',
		'lua-language-server',
		'bash-language-server',
		'python-lsp-server',
		'basedpyright',
		'ruff_lsp',
		'shellcheck',
		'texlab',
	},
}


-- copied from after/plugin/nvim-cmp.lua, because `capabilities` was flagged unknown by LSP
-- Extends completion features, s. https://github.com/hrsh7th/cmp-nvim-lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--> Check output of :LspInfo (maybe using <Tab> afterwards) for useful information!
--
-- TODO: Different setup schemes for different LSPs <04-07-2024>
-- Due to reasons I don't understand doesn't 'servers' work with the other LSPs
-- And the manual setup, fi with python, doesn't work with lua_ls.
local servers = {
	-- https://luals.github.io/wiki/settings/
	-- mytable@…: mytable@inse<C-Enter> -> table.insert(mytable, )
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			diagnostics = { globals = { 'vim' } }, -- Get the language server to recognize the `vim` global
			completion = {
				callSnippets = "Both",            -- "Disable", "Replace"
				displayContext = 6,
			},
			-- hint.enable -> hint = { enable … }
			hint = {
				enable = true,
				arrayIndex = 'Enable',
				setType = true,
			},
		}
	},
}


-- Ensure the servers above are installed
---@diagnostic disable-next-line: missing-fields
mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}
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


-- Manual LSP configuration
-- ────────────────────────

local lspconfig = require 'lspconfig'

-- ─── Python ──────────
--[[
Example from https://www.reddit.com/r/neovim/comments/1bt3dy0/comment/l5813wf/?context=3

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
			-- Used for open_meteo
			reportOptionalMemberAccess = "none",
			-- reportImplicitOverride = false,
			reportMissingSuperCall = "none",
			-- reportUnusedImport = false,
			-- basedpyright very intrusive with errors, this calms it down
			typeCheckingMode = "standard",
			-- works, if pyproject.toml is used
			reportAttributeAccessIssue = false,
			-- reportUnknownVariableType = 'none',
			-- doesn't work, even if pyproject.toml is used
			analysis = {
				inlayHints = {
					callArgumentNames = true -- = basedpyright.analysis.inlayHints.callArgumentNames
				}
			}
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
				-- All disabled to avoid overlap with ruff
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
					enabled = false,
				},
			}
		}
	}
}

-- Configure `ruff-lsp`.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings
-- Currently, I am using ~/.config/ruff/ruff.toml to control ruff-lsp
lspconfig.ruff.setup {
	init_options = {
		settings = {
			-- Any extra CLI arguments for `ruff` go here.
			args = {},
		}
	}
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
