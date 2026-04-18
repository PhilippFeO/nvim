-- Doc: https://luals.github.io/
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
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
      -- Doc: https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md#trailing_table_separator
      -- .editoconfig will take priority
      format = {
        enable = true,
        defaultConfig = {
          space_around_assign_operator = 'true',
          -- `f('lorem')('ipsum')` wont becom `f 'lorem' 'ipsum'`
          call_arg_parentheses = 'always',
          -- smart means that if all items in the table are in the same row, the separator for the last item is removed, otherwise the end separator is added
          trailing_table_separator = 'smart',
          align_if_branch = 'true',
          never_indent_comment_on_if_branch = 'true',
          break_all_list_when_line_exceed = 'true',
          remove_call_expression_list_finish_comma = 'true',
        },
      },
    },
  },
})


-- When using Mason, this is done automatically, s. `h mason-lspconfig-settings`
-- vim.lsp.enable('luals')
