-- LSP related keymaps
-- required in ./after/plugin/mason.lua

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- We create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- Opens a buffer for every file containing the identifier, ie. ":wa" necessary, although one file was opened originally
  nmap('<leader>r', vim.lsp.buf.rename, '[r]ename')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')

  nmap('<Leader>i', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
  end, '[i]nlay hints')

  nmap('gd', vim.lsp.buf.definition, '[g]oto [g]efinition (as in plain vim)')
  nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
  nmap('gi', vim.lsp.buf.implementation, '[g]oto [i]mplementation')
  nmap('gy', vim.lsp.buf.type_definition, '[g]oto t[y]pe definition')
  nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')
  -- basically a searchable structure/outline of the document
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')

  -- Lesser used LSP functionality
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- "Workspace" related
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[w]orkspace [a]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [r]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[w]orkspace [l]ist Folders')

  -- '<C-w>d' can be substituted by 'vim.diagnostic.open_float'
  vim.keymap.set('n', '<Leader>e', '<C-w>d', { remap = true, desc = "Open floating diagnostic message" })
  nmap('<Leader>q', vim.diagnostic.setloclist, "Open diagnostics list as Location List")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

return on_attach
