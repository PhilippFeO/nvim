-- `h lsp-config`
-- Configs can be distributed across files, s `h lsp-config` for more information.

-- Copied from after/plugin/nvim-cmp.lua, because `capabilities` was flagged unknown by LSP
-- Extends completion features, s. https://github.com/hrsh7th/cmp-nvim-lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


-- -- Configure `ruff-lsp`.
-- -- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ruff_lsp
-- -- For the default config, along with instructions on how to customize the settings
-- -- Currently, I am using ~/.config/ruff/ruff.toml to control ruff-lsp
-- lspconfig.ruff.setup {
--   init_options = {
--     settings = {
--       -- Any extra CLI arguments for `ruff` go here.
--       args = {},
--     }
--   }
-- }
