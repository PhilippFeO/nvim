-- https://docs.basedpyright.com/v1.23.1/
vim.lsp.config['basedpyright'] = {
	-- on_attach = on_attach,
	-- capabilities = capabilities,
	settings = {
		basedpyright = {
			reportUnusedCallResult = false,
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


-- When using Mason, this is done automatically, s. `h mason-lspconfig-settings`
-- vim.lsp.enable('basedpyright')
