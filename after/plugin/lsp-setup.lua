local border = require('utils').border

vim.diagnostic.config({
  virtual_text = true, -- Show diagnostics next to the code
  ---@diagnostic disable-next-line: assign-type-mismatch
  float = { border = border },
})


-- Keymaps
-- ───────
-- We create a function that lets us more easily define mappings specific
-- for LSP related items. It sets the mode, buffer and description for us each time.
vim.keymap.set(
  { 'n', 'v' }, 'K',
  function()
    -- without this line the nvim-ufo preview doesn't work
    local _ = require('ufo').peekFoldedLinesUnderCursor()
    vim.lsp.buf.hover({
      border = border,
    })
  end,
  { desc = 'Hover' }
)
vim.keymap.set(
  'n', '<Leader>e',
  vim.diagnostic.open_float, -- '<C-w>d' == 'vim.diagnostic.open_float'
  {
    remap = true,
    desc = "Open floating diagnostic message",
  }
)
vim.keymap.set(
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
vim.keymap.set(
  'n',
  '<Leader>as',
  require('telescope.builtin').lsp_dynamic_workspace_symbols,
  { desc = lsp_desc('[a]ll workspace [s]ymbols') }
)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(ev)
    -- Copied from https://www.youtube.com/watch?v=ZiH59zg59kg
    -- Which mechanics are enabled is currently unclear
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client ~= nil and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    -- Dont forget LSP default mappings: `h lsp-defaults`
    vim.keymap.set(
      'n', 'grd',
      vim.lsp.buf.declaration,
      { desc = lsp_desc('[g]oto [d]eclaration') }
    )
    vim.keymap.set(
      'n', 'grD',
      vim.lsp.buf.definition,
      { desc = lsp_desc('[g]oto [D]efinition (as in plain vim)') }
    )
    vim.keymap.set(
      'n', '<Leader>ds',
      require('telescope.builtin').lsp_document_symbols,
      { desc = lsp_desc('[d]ocument [s]ymbols') })
    vim.keymap.set(
      'n', 'gO',
      require('telescope.builtin').lsp_document_symbols,
      {
        remap = true,
        desc = lsp_desc('document symbols (remapped to use telescope)'),
      }
    )
    vim.keymap.set(
      'n', 'grr',
      require('telescope.builtin').lsp_references,
      {
        -- remap = true,
        desc = '[g]oto [rr]eferences',
      }
    )
    vim.keymap.set(
      'n', '<Leader>i',
      function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
      end,
      { desc = lsp_desc('[i]nlay hints') }
    )

    -- difference to `h vim.lsp.buf.hover` unclear
    -- Guess, hover is more general
    vim.keymap.set(
      'n', '<C-k>',
      vim.lsp.buf.signature_help,
      { desc = lsp_desc('Signature Documentation') }
    )

    -- Workspace related
    vim.keymap.set(
      'n',
      '<Leader>as',
      require('telescope.builtin').lsp_dynamic_workspace_symbols,
      { desc = lsp_desc('[a]ll workspace [s]ymbols') }
    )
    vim.keymap.set(
      'n',
      '<leader>ld',
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      { desc = lsp_desc('[l]ist all workspace [d]irectories/folders') }
    )
  end,
  desc = 'Lorem Ipsum',
})
