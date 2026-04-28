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
  callback = function(args)
    -- `h lsp-format`

    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- if client:supports_method('textDocument/implementation') then
    --   -- Create a keymap for vim.lsp.buf.implementation ...
    -- end

    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client ~= nil and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if  not client:supports_method('textDocument/willSaveWaitUntil')
    and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end

    -- Dont forget LSP default mappings: `h lsp-defaults`
    vim.keymap.set('n', 'gd', 'gdzz',
      {
        remap = true,
        desc = '[g]oto [d]eclaration via Vim default gd and center (only within file)',
      })
    vim.keymap.set('n', 'gdl',
      vim.lsp.buf.declaration,
      { desc = lsp_desc('[g]oto [d]eclaration via LSP') }
    )
    vim.keymap.set('n', 'gD',
      vim.lsp.buf.definition,
      { desc = lsp_desc('[g]oto [D]efinition') }
    )
    vim.keymap.set('n', '<Leader>ds',
      require('telescope.builtin').lsp_document_symbols,
      { desc = lsp_desc('[d]ocument [s]ymbols') })
    vim.keymap.set('n', 'gO',
      require('telescope.builtin').lsp_document_symbols,
      {
        remap = true,
        desc = lsp_desc('document symbols (remapped to use telescope)'),
      }
    )
    vim.keymap.set('n', 'grr',
      require('telescope.builtin').lsp_references,
      {
        -- remap = true,
        desc = '[g]oto [rr]eferences',
      }
    )
    vim.keymap.set('n', '<Leader>i',
      function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
      end,
      { desc = lsp_desc('[i]nlay hints') }
    )

    -- ś makes only sense with NeoQWERTZ
    vim.keymap.set(
      'i', 'ś',
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
