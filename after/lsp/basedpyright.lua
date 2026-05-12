-- When using Mason, this is done automatically, s. `h mason-lspconfig-settings`
-- vim.lsp.enable('basedpyright')


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
			-- basedpyright is very intrusive with errors, this calms it down
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
			-- Use custom python path for arcpy projects
			-- https://docs.basedpyright.com/v1.21.1/configuration/command-line/
			pythonPath =
					(function()
						local root_dir = require 'lspconfig.util'.root_pattern('.git')('.')
						if root_dir ~= nil and string.find(root_dir, 'e.on-mining', 1, true) ~= nil then
							return vim.fn.expand(root_dir .. '/.venv/python.exe')
						else
							-- fallback to system's python path or python path of active venv
							return vim.fn.exepath('python')
						end
					end)()
		},
	}
}
