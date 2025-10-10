local border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }

vim.keymap.set(
  { 'n', 'v' },
  'K',
  function()
    vim.lsp.buf.hover({
      border = border
    })
  end,
  { desc = 'Hover', }
)

vim.diagnostic.config({
  virtual_text = true, -- Show diagnostics next to the code
  ---@diagnostic disable-next-line: assign-type-mismatch
  float = { border = border },
})


-- Keymaps
-- ───────
-- We create a function that lets us more easily define mappings specific
-- for LSP related items. It sets the mode, buffer and description for us each time.
local nmap = function(keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end

  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end



vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    -- '<C-w>d' == 'vim.diagnostic.open_float'
    vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float,
      { remap = true, desc = "Open floating diagnostic message" })
    nmap('<Leader>q', vim.diagnostic.setloclist, "Open diagnostics list as Location List")

    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')

    -- Workspace related
    nmap('<leader>as', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[a]ll workspace [s]ymbols')
    nmap('<leader>af', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[a]ll workspace list [f]olders')
  end,
  desc = 'Lorem Ipsum',
})
