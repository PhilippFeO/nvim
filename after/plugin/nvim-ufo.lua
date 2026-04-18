-- https://github.com/kevinhwang91/nvim-ufo


-- ─── Foldcolumn ──────────
-- Basically the width of columns for indicating folds
-- '0': No foldcolumn at all
-- '1': Merges multiple foldlevels into one column (or in general: #foldlevel < #foldcolumn merging is done)''
-- 'auto[1-9]': automatic width of foldcolumn depending on foldlevel
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99 -- Using ufo provider needs a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
-- Only visible if `h foldcolumn` > 0
vim.opt.fillchars:append({
  fold = '',
  -- foldopen = '',
  foldopen = '',
  foldclose = '',
  foldsep = ' ', -- No '|'
  -- foldinner = ' ',
})


-- ─── Keymaps ──────────
-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', function()
  require('ufo').openAllFolds()
  vim.cmd.normal('zz')
end
)
vim.keymap.set('n', 'zM', function()
  require('ufo').closeAllFolds()
  vim.cmd.normal('zz')
end)
-- Toggle Folds via <CR>
vim.keymap.set('n', '<CR>', 'za', { remap = true })


-- ─── Highlight Groups ──────────
local kanagawa_colors = require("kanagawa.colors").setup().palette
local normal_bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg -- is returned in Decimal not Hexadecimal
vim.api.nvim_set_hl(0, 'UfoFoldPreviewBorder', {
  fg = kanagawa_colors.sakuraPink,
  bg = string.format('#%06x', normal_bg),
})
-- Do not highlight Folded lines. This creates to much visual noise, ...
vim.api.nvim_set_hl(0, 'Folded', {
  bg = string.format('#%06x', normal_bg),
})
-- ... rather work with a brigh UfoFoldedEllipsis.
vim.api.nvim_set_hl(0, 'UfoFoldedEllipsis', {
  fg = kanagawa_colors.waveAqua1,
})
-- Color is the original bg color for Folded. A construction as for `normal_bg` can't be used because Folded is altered within this file, hence it would yield the new bg value.
vim.api.nvim_set_hl(0, 'UfoFoldedBg', {
  bg = '#2a2a37',
})


--- Custom function to display the folded line, here:
---   `<Contents of line> + <suffix>`.
--- As far as I can see, the contents of the line have to be collected explicitly, bevore the suffix is appended but I haven't inspected the code in detail. Code taken from the README.md.
local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' 󰁂 %d '):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  --- Highlight Group for the suffix
  table.insert(newVirtText, { suffix, 'UfoFoldedEllipsis' })
  return newVirtText
end

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
  fold_virt_text_handler = handler,
  ---@diagnostic disable-next-line: unused-local
  provider_selector = function(bufnr, filetype, buftype)
    return { 'treesitter', 'indent' }
  end,
  -- Treesitter nodes (because I am using treesitter as provider) which shall be folded per default, ie
  -- when I open the file.
  -- As far as I can tell, they have to be a subset of the nodes mentioned in queries/python/folds.scm. Just having the file doesnt work.
  --  'call' DOES NOT mean to close every Call but only these matching the ones from `folds.scm`.
  close_fold_kinds_for_ft = {
    python = { 'function_definition', 'call', 'import_statement', 'import_from_statement', 'assignment' },
  },
  -- If `true`, folds are closed if, fi. `vim.lsp.buf.hover()` is used to open a floating window, which is kinda annoying.
  close_fold_current_line_for_ft = {
    python = false,
  },
  -- Per
  --  require('ufo.preview'):peekFoldedLinesUnderCursor(enter, nextLineIncluded)
  -- kann ein Vorschaufenster des gerafften Codes geöffnet werden, s. lsp-setup.lua, für Keymap (analog zu `K`).
  -- Keymaps to switch, scroll, etc. in preview window: `h ufo`.
  preview = {
    win_config = {
      winblend = 0,
      border = require('utils').border,
      -- Normal: Basically the Background of the Editor
      winhighlight = 'Normal:Normal,FloatBorder:UfoFoldPreviewBorder',
    },
    mappings = {
      switch = 'K',
      scrollU = '<C-u>',
      scrollD = '<C-d>',
    },
  },
})
