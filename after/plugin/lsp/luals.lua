vim.lsp.config['luals'] = {
  -- Command and arguments to start the server. When using Mason this is done automatically.
  -- cmd = { vim.fn.expand '~/Downloads/lua-language-server-3.15.0-linux-x64/bin/lua-language-server' },
  -- Filetypes to automatically attach to.
  filetypes = { 'lua' },
  -- Sets the "workspace" to the directory where any of these files is found.
  -- Files that share a root directory will reuse the LSP server connection.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, 'init.lua', '.git' },
  -- Specific settings to send to the server. The schema is server-defined.
  -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { 'vim' } }, -- Get the language server to recognize the `vim` global
      completion = {
        callSnippets = "Both",               -- "Disable", "Replace"
        displayContext = 6,
      },
      -- hint.enable -> hint = { enable … }
      hint = {
        enable = true,
        arrayIndex = 'Enable',
        setType = true,
      },
    }
  }
}

-- When using Mason, this is done automatically, s. `h mason-lspconfig-settings`
-- vim.lsp.enable('luals')
