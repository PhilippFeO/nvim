-- When using Mason, this is done automatically, s. `h mason-lspconfig-settings`
-- vim.lsp.enable('pylsp')

-- Maybe helpful: https://www.reddit.com/r/neovim/comments/1bt3dy0/comment/l5813wf/?context=3
return {
	-- capabilities = capabilities,
	on_attach = function(client, bufnr)
		-- Show available capabilities:
		--	`lua =vim.lsp.get_active_clients()[2]`
		--	`tabnew | put = execute('messages')`
		-- disable some capabilities and use basedpyright instead
		client.server_capabilities.hoverProvider = false
		client.server_capabilities.renameProvider = false
		client.server_capabilities.definitionProvider = false
		client.server_capabilities.declarationProvider = false
		client.server_capabilities.referencesProvider = false
		-- signatureHelpProvider takes a table as argument (default):
		--		signatureHelpProvider = {
		--			triggerCharacters = { "(", ",", "=" }
		--		},
		-- To disable it, delete the entry by setting it to nil
		client.server_capabilities.signatureHelpProvider = nil
	end,
	settings = {
		pylsp = {
			python = {
				analysis = {
					diagnosticSeverityOverrides = {
						-- reportUnusedCallResult = "none", -- Disable unused call expression reporting
					},
				},
			},
			-- :PyLspInstall <tab>
			plugins = {
				-- Unklar, was es macht, wird ggfl. auch von Ruff übernommen
				rope = {
					enabled = false,
				},
				-- All disabled to avoid overlap with ruff
				pycodestyle = {
					enabled = false,
				},
				mccabe = {
					enabled = false,
				},
				pydocstyle = {
					enabled = false,
				},
				yapf = {
					enabled = false,
				},
				autopep8 = {
					enabled = false,
				},
			},
		},
	},
}
