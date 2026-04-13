-- https://github.com/kevinhwang91/nvim-ufo


vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'yR', require('ufo').openAllFolds)
vim.keymap.set('n', 'yM', require('ufo').closeAllFolds)

vim.api.nvim_set_hl(0, 'NvimUfoFoldPreviewBorder', {
  fg = require("kanagawa.colors").setup().palette.sakuraPink,
  bg = '#1f1f28',
})

-- -- Option 2: nvim lsp as LSP client
-- -- Tell the server the capability of foldingRange,
-- -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.foldingRange = {
--   dynamicRegistration = false,
--   lineFoldingOnly = true
-- }
-- local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
-- for _, ls in ipairs(language_servers) do
--   require('lspconfig')[ls].setup({
--     capabilities = capabilities
--     -- you can add other fields for setting up lsp server in this table
--   })
-- end
-- require('ufo').setup()

-- Option 3: treesitter as a main provider instead
-- (Note: the `nvim-treesitter` plugin is *not* needed.)
-- ufo uses the same query files for folding (queries/<lang>/folds.scm)
-- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
require('ufo').setup({
  -- How long the unfolded code will be highlighted
  open_fold_hl_timeout = 2000,
  provider_selector = function(bufnr, filetype, buftype)
    return { 'treesitter', 'indent' }
  end,
  -- Treesitter nodes (because I am using treesitter as provider) which shall be folded per default, ie
  -- when I open the file.
  -- As far as I can tell, they have to be a subset of the nodes mentioned in queries/python/folds.scm. Just having the file doesnt work.
  --  'call' DOES NOT mean to close every Call but only these matching the ones from `folds.scm`.
  close_fold_kinds_for_ft = {
    python = { 'function_definition', 'call', 'import_statement', 'import_from_statement', 'assignment', },
  },
  -- If `true`, folds are closed if, fi. `vim.lsp.buf.hover()` is used to open a floating window, which is kinda annoying.
  close_fold_current_line_for_ft = {
    python = false,
  },
  -- Per
  --  require('ufo.preview'):peekFoldedLinesUnderCursor(enter, nextLineIncluded)
  --  kann ein Vorschaufenster des gerafften Codes geöffnet werden.
  --  s. lsp-setup.lua, für Keymap (analog zu `K`).
  --  Keymaps to switch, scroll, etc. in preview window: `h ufo`.
  preview = {
    win_config = {
      winblend = 0,
      border = require('utils').border,
      -- Normal: Basically the Background of the Editor
      winhighlight = 'Normal:Normal,FloatBorder:NvimUfoFoldPreviewBorder'
    }
  },
})
