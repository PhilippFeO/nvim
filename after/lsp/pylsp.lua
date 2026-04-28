-- When using Mason, this is done automatically, s. `h mason-lspconfig-settings`
-- vim.lsp.enable('pylsp')

-- Maybe helpful: https://www.reddit.com/r/neovim/comments/1bt3dy0/comment/l5813wf/?context=3
vim.lsp.config('pylsp', {
	-- capabilities = capabilities,
	on_attach = function(client, bufnr)
		-- Show available capabilities:
		--	`lua =vim.lsp.get_active_clients()[2]`
		--	`tabnew | put = execute('messages')`
		-- disable some capabilities and use basedpyright instead
		client.server_capabilities.hoverProvider = false
		client.server_capabilities.renameProvider = false
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
						reportUnusedCallResult = "none", -- Disable unused call expression reporting
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
			},
		},
	},
}
)

