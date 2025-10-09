
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)

  -- Opens a buffer for every file containing the identifier, ie. ":wa" necessary, although one file was opened originally
  -- nmap('<leader>r', vim.lsp.buf.rename, '[r]ename')
  -- nmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction')

  nmap('<Leader>i', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
  end, '[i]nlay hints')

  nmap('gd', function()
    vim.lsp.buf.definition()
  end, '[g]oto [g]efinition (as in plain vim)')
  nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
  nmap('gi', vim.lsp.buf.implementation, '[g]oto [i]mplementation')
  nmap('gy', vim.lsp.buf.type_definition, '[g]oto t[y]pe definition')
  nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')

  -- Lesser used LSP functionality
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

end

return on_attach
