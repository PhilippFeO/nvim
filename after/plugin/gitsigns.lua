require('gitsigns').setup {
  signs               = {
    -- Colors may be changed via the according highlight groupd, check :h gitsigns-highlight-groups
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '󰧧' },
    topdelete    = { text = '󰆴' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn          = true,  -- Toggle with `:Gitsigns toggle_signs`
  -- different highlight options
  numhl               = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl              = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff           = false, -- Toggle with `:Gitsigns toggle_word_diff`
  -- Watch changes
  watch_gitdir        = {
    enable = true,
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  -- Virtual text with information about the commit where it originates
  -- current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  -- current_line_blame_opts = {
  --   virt_text = true,
  --   virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
  --   delay = 1000,
  --   ignore_whitespace = false,
  -- },
  -- current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority       = 6,     -- should be below LSP signs
  update_debounce     = 100,
  status_formatter    = nil,   -- Use default
  max_file_length     = 40000, -- Disable if file is longer than this (in lines)
  preview_config      = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  on_attach           = function(bufnr)
    local gs = package.loaded.gitsigns

    local function prepend_desc(desc)
      if desc then
        desc = '󰊢 GS: ' .. desc
      end
      return desc
    end

    local function map(mode, l, r, opts, desc)
      opts = opts or {}
      opts.buffer = bufnr
      opts.desc = prepend_desc(desc)
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })


    -- helper function with empty {}
    local function map2(mode, l, r, desc)
      map(mode, l, r, {}, desc)
    end

    -- Actions
    map2('n', '<leader>hs', gs.stage_hunk, 'Stage Hunk')
    map2('n', '<leader>hr', gs.reset_hunk, 'Reset Hunk')
    map2('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Stage Hunk')
    map2('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, 'Reset Hunk')
    map2('n', '<leader>hS', gs.stage_buffer, 'Stage Buffer')
    map2('n', '<leader>hu', gs.undo_stage_hunk, 'Undo Stage Hunk')
    map2('n', '<leader>hR', gs.reset_buffer, 'Reset Buffer')
    map2('n', '<leader>hh', gs.preview_hunk, 'Preview Hunk')
    map2('n', '<leader>bl', function() gs.blame_line { full = true } end, 'Blame Line')
    map2('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle Current Line Blame')
    -- open diff for current buffer
    map2('n', '<leader>hd', gs.diffthis, 'Open diff for current buffer')
    -- '~' == '~1'
    map2('n', '<leader>hD', function() gs.diffthis('~') end, "Git diff against previous Commit")
    map2('n', '<leader>td', gs.toggle_deleted, 'Toggle Deleted')

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
