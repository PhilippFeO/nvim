local keymap_set = vim.keymap.set
local border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }


vim.diagnostic.config({
  virtual_text = true, -- Show diagnostics next to the code
  ---@diagnostic disable-next-line: assign-type-mismatch
  float = { border = border },
})


-- Keymaps
-- ───────
-- We create a function that lets us more easily define mappings specific
-- for LSP related items. It sets the mode, buffer and description for us each time.
keymap_set(
  { 'n', 'v' }, 'K',
  function()
    vim.lsp.buf.hover({
      border = border
    })
  end,
  { desc = 'Hover', }
)
keymap_set(
  'n', '<Leader>e',
  vim.diagnostic.open_float, -- '<C-w>d' == 'vim.diagnostic.open_float'
  {
    remap = true,
    desc = "Open floating diagnostic message"
  }
)
keymap_set(
  'n', '<Leader>q',
  vim.diagnostic.setloclist,
  { desc = "Open diagnostics list as Location List" }
)

local function lsp_desc(desc)
  return 'LSP: ' .. desc
end

-- TODO: To make this work via the command line, ie
-- `nvim -c "Telescope lsp_dynamic_workspace_symbols`,
-- the LSP has to be started beforehand, even if non python
-- file (fi. plain nvim) was opened.
keymap_set(
  'n',
  '<Leader>as',
  require('telescope.builtin').lsp_dynamic_workspace_symbols,
  { desc = lsp_desc('[a]ll workspace [s]ymbols') }
)




vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(_)
    -- Dont forget LSP default mappings: `h lsp-defaults`

    keymap_set(
      'n', 'grd',
      vim.lsp.buf.declaration,
      { desc = lsp_desc('[g]oto [d]eclaration') }
    )
    keymap_set(
      'n', 'grD',
      vim.lsp.buf.definition,
      { desc = lsp_desc('[g]oto [D]efinition (as in plain vim)') }
    )
    keymap_set(
      'n', '<Leader>ds',
      require('telescope.builtin').lsp_document_symbols,
      { desc = lsp_desc('[d]ocument [s]ymbols') })
    keymap_set(
      'n', 'gO',
      require('telescope.builtin').lsp_document_symbols,
      {
        remap = true,
        desc = lsp_desc('document symbols (remapped to use telescope)')
      }
    )
    keymap_set(
      'n', 'grr',
      require 'telescope.builtin'.lsp_references,
      {
        -- remap = true,
        desc = '[g]oto [rr]eferences',
      }
    )
    keymap_set(
      'n', '<Leader>i',
      function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
      end,
      { desc = lsp_desc('[i]nlay hints') }
    )

    -- difference to `h vim.lsp.buf.hover` unclear
    -- Guess, hover is more general
    keymap_set(
      'n', '<C-k>',
      vim.lsp.buf.signature_help,
      { desc = lsp_desc('Signature Documentation') }
    )

    -- Workspace related
    keymap_set(
      'n',
      '<Leader>as',
      require('telescope.builtin').lsp_dynamic_workspace_symbols,
      { desc = lsp_desc('[a]ll workspace [s]ymbols') }
    )
    keymap_set(
      'n',
      '<leader>af',
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      { desc = lsp_desc('[a]ll workspace list [f]olders') }
    )
  end,
  desc = 'Lorem Ipsum',
})
