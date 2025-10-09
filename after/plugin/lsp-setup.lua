-- -- Configure Border of LSP induced Floating Windows
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
--   vim.lsp.handlers.hover, {
--     -- Use a sharp border with `FloatBorder` highlights
--     border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, -- chars from kanagawa.nvim
--     -- add the title in hover float window
--     -- title = "hover"
--   }
-- )

--[[

lsp.txt:
with({handler}, {override_config})                            *vim.lsp.with()*
    Function to manage overriding defaults for LSP handlers.

    Parameters: ~
      • {handler}          (`lsp.Handler`) See |lsp-handler|
      • {override_config}  (`table`) Table containing the keys to override
                           behavior of the {handler}

                                                                 *lsp-handler*
LSP handlers are functions that handle |lsp-response|s to requests made by Nvim
to the server. (Notifications, as opposed to requests, are fire-and-forget:
there is no response, so they can't be handled. |lsp-notification|)

Each response handler has this signature: >

    function(err, result, ctx, config)
<
    Parameters: ~
      • {err}     (`table|nil`) Error info dict, or `nil` if the request
                  completed.
      • {result}  (`Result|Params|nil`) `result` key of the |lsp-response| or
                  `nil` if the request failed.
      • {ctx}     (`table`) Table of calling state associated with the
                  handler, with these keys:
                  • {method}     (`string`) |lsp-method| name.
                  • {client_id}  (`number`) |vim.lsp.Client| identifier.
                  • {bufnr}      (`Buffer`) Buffer handle.
                  • {params}     (`table|nil`) Request parameters table.
                  • {version}    (`number`) Document version at time of
                                 request. Handlers can compare this to the
                                 current document version to check if the
                                 response is "stale". See also |b:changedtick|.
      • {config}  (`table`) Handler-defined configuration table, which allows
                  users to customize handler behavior.
                  For an example, see:
                      |vim.lsp.diagnostic.on_publish_diagnostics()|
                  To configure a particular |lsp-handler|, see:
                      |lsp-handler-configuration|

    Returns: ~
        Two values `result, err` where `err` is shaped like an RPC error: >
            { code, message, data? }
<        You can use |vim.lsp.rpc.rpc_response_error()| to create this object.


                                           *vim.lsp.handlers.signature_help()*
signature_help({_}, {result}, {ctx}, {config})
    |lsp-handler| for the method "textDocument/signatureHelp".

    The active parameter is highlighted with |hl-LspSignatureActiveParameter|. >lua
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
          vim.lsp.handlers.signature_help, {
            -- Use a sharp border with `FloatBorder` highlights
            border = "single"
          }
        )
<

    Parameters: ~
      • {result}  (`lsp.SignatureHelp`) Response from the language server
      • {ctx}     (`lsp.HandlerContext`) Client context
      • {config}  (`table`) Configuration table.
                  • border: (default=nil)
                    • Add borders to the floating window
                    • See |vim.lsp.util.open_floating_preview()| for more
                      options


--]]

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single",
    -- add the title in hover float window
    title = "hover"
  }
)

-- Show diagnostics next to the code
vim.diagnostic.config({ virtual_text = true })


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
