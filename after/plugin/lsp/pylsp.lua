vim.lsp.config['pylsp'] = {
	-- on_attach = on_attach,
	-- capabilities = capabilities,
	settings = {
		pylsp = {
			python = {
				analysis = {
					diagnosticSeverityOverrides = {
						reportUnusedCallResult = "none" -- Disable unused call expression reporting
					},
				},
			},
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
					-- maxLineLength = 154
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

-- When using Mason, this is done automatically, s. `h mason-lspconfig-settings`
-- vim.lsp.enable('pylsp')
