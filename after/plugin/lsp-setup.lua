local border = require('utils').border


-- Recommend by (s. video) https://gpanders.com/blog/whats-new-in-neovim-0-11/
-- 2026-05-18: I don't see any effect, hence disabled
-- vim.cmd('set completeopt+=noselect')


vim.diagnostic.config({
  virtual_text = true, -- Show diagnostics next to the code
  ---@diagnostic disable-next-line: assign-type-mismatch
  float = {
    border = border,
    ---@alias HighlightGroup string Name of a Highlight Group
    ---@return string, HighlightGroup
    -- I prefere this style for displaying the source of a dignostic over `source=true/'if_many'` which prepends the source in red, so it is barely distinguishible.
    suffix = function(diagnositc, _, _)
      return string.format(' [%s, %s]', diagnositc.code, diagnositc.source), ''
    end
  },

})


-- Keymaps
-- ───────
--- Enable Preview of folded Lines or LSP-Information on K
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
vim.keymap.set('n', 'gK', function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result)
    if not result or vim.tbl_isempty(result) then return end
    local def   = vim.islist(result) and result[1] or result
    local bufnr = vim.uri_to_bufnr(def.uri or def.targetUri)
    vim.fn.bufload(bufnr)
    vim.treesitter.get_parser(bufnr, 'python'):parse()

    local range = def.range or def.targetRange
    local node  = vim.treesitter.get_node({
      bufnr = bufnr,
      pos   = { range.start.line, range.start.character },
    })

    while node and node:type() ~= 'assignment' do
      node = node:parent()
    end
    if not node then return end

    local lines = vim.split(vim.treesitter.get_node_text(node, bufnr), '\n')
    vim.lsp.util.open_floating_preview(lines, 'python', { border = 'rounded' })
  end)
end, { desc = 'Hover with full assignment/definition' })

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

    -- -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    -- if client ~= nil and client:supports_method('textDocument/completion') then
    --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    -- end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
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
    -- The Vim mapping 'gd' sometimes goes to the first occurence of a symbol, for instance to a location in a comment/docstring coming before the actual declaration, s. `h gd`. Better use `vim.lsp.buf.declaration()`.
    local goto_implementation = function()
      vim.lsp.buf.implementation()
      vim.defer_fn(function() vim.cmd('normal zz') end, 50)
    end
    vim.keymap.set('n', 'gri', goto_implementation,
      { remap = true, desc = lsp_desc('[g]oto [i]mplementation') }
    )
    vim.keymap.set('n', 'griv', function()
        vim.cmd('vsplit')
        goto_implementation()
      end,
      { desc = lsp_desc('[g]oto [i]mplementation in [v]split') }
    )
    vim.keymap.set('n', 'gdv', 'gdzz',
      {
        remap = true,
        desc = '[g]oto [d]eclaration via Vim default gd and center (only within file)',
      })
    vim.keymap.set('n', 'gd', function()
        vim.lsp.buf.declaration()
        vim.cmd('normal zz')
      end,
      { desc = lsp_desc('[g]oto [d]eclaration via LSP') }
    )
    vim.keymap.set('n', 'gD', function()
        vim.lsp.buf.definition()
        vim.cmd('normal zz')
      end,
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
    -- Default: <C-s>
    vim.keymap.set('i', 'ś',
      vim.lsp.buf.signature_help,
      { desc = lsp_desc('Signature Documentation') }
    )

    -- Workspace related
    vim.keymap.set('n',
      '<Leader>as',
      require('telescope.builtin').lsp_dynamic_workspace_symbols,
      { desc = lsp_desc('[a]ll workspace [s]ymbols') }
    )
    vim.keymap.set('n',
      '<leader>ld',
      function()
        vim.lsp.buf.list_workspace_folders()
      end,
      { desc = lsp_desc('[l]ist all workspace [d]irectories/folders') }
    )

    vim.keymap.set('n', '<Leader>lc', function()
      local clients = vim.lsp.get_clients({ bufnr = args.buf })
      if #clients == 0 then
        vim.notify('No LSP clients attached', vim.log.levels.WARN)
        return
      end

      local function open_caps(selected)
        vim.cmd('tabnew')
        for i, c in ipairs(selected) do
          if i > 1 then vim.cmd('vsplit') end
          local buf = vim.api.nvim_create_buf(false, true)
          local lines = vim.split(vim.inspect(c.server_capabilities), '\n')
          table.insert(lines, 1, '')
          table.insert(lines, 1, '-- ' .. c.name)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          vim.bo[buf].filetype = 'lua'
          vim.bo[buf].modifiable = false
          vim.api.nvim_win_set_buf(0, buf)
        end
      end

      if #clients == 1 then
        open_caps(clients)
        return
      end

      local pickers      = require('telescope.pickers')
      local finders      = require('telescope.finders')
      local conf         = require('telescope.config').values
      local actions      = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      pickers.new({}, {
        prompt_title = 'Select LSP Clients',
        finder = finders.new_table({
          results = clients,
          entry_maker = function(c)
            return { value = c, display = c.name, ordinal = c.name }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          map('i', '<Tab>', actions.toggle_selection)
          map('n', '<Tab>', actions.toggle_selection)
          actions.select_default:replace(function()
            local picker = action_state.get_current_picker(prompt_bufnr)
            local selections = picker:get_multi_selection()
            if #selections == 0 then
              selections = { action_state.get_selected_entry() }
            end
            actions.close(prompt_bufnr)
            open_caps(vim.tbl_map(function(s) return s.value end, selections))
          end)
          return true
        end,
      }):find()
    end, { desc = lsp_desc('[l]sp [c]apabilities') })
  end,
  desc = 'Commands when a LSP attaches',
})
