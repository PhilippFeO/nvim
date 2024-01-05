-- ╭─────────────────────────╮
-- │ Telescope Configuration │
-- ╰─────────────────────────╯
-- See `:help telescope`

local actions = require('telescope.actions')

require('telescope').setup { -- :h telescope.setup()
  defaults = {
    mappings = {
      n = {
        -- There is also `send_selected_to_qflist`
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist
      },
      i = {
        ['<C-u>'] = true,
        ['<C-d>'] = true,
        -- ["<C-h>"] = "which_key",
      },
    },
    prompt_prefix = '  ',
    selection_caret = '  ',
    entry_prefix = '   ',
    -- path_display = { 'shorten', shorten = 4 },
    layout_config = {
      preview_width = 0.5,
      prompt_position = 'top'
    },
    -- Otherwise the first results show on the bottom although prompt is on top
    sorting_strategy = 'ascending',
    -- might interfere with lsp_ pickers
    file_ignore_patterns = {
      "*.tif", -- heavily used in earth-observation/
      "*.tiff",
      "*.TIF",
      "%.png",
      "/bilder/"
    },
  },
}
require('telescope').load_extension('dap')
-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

vim.api.nvim_set_hl(0, 'TelescopeBorder', { link = 'TelescopeNormal' })
-- vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = '', fg = '#555555' })

-- Keymaps
-- ───────
local builtin = require('telescope.builtin')

local prepend_desc = function(desc)
  if desc then
    --     󰭎    🔭
    desc = ' Tel: ' .. desc
  end

  return desc
end

local nmap = function(keys, func, desc)
  if desc then
    desc = prepend_desc(desc)
  end

  vim.keymap.set('n', keys, func, { desc = desc })
end

-- ─── [f]ind keymaps ──────────
nmap('<Leader>f', builtin.find_files, 'find [f]iles')

-- ─── [s]earch keymaps ──────────
nmap('<Leader>sa', builtin.autocommands, '[s]earch [a]utocommands')
nmap('<Leader>sb', builtin.buffers, '[s]earch existing [b]uffers')
nmap('<Leader>sC', builtin.commands, '[s]earch [C]ommands')
nmap('<Leader>sd', builtin.diagnostics, '[s]earch [d]iagnostics')
nmap('<Leader>sg', builtin.live_grep, '[s]earch project with [g]rep')
nmap('<Leader>sh', builtin.help_tags, '[s]earch [h]elp')
nmap('<Leader>sk', builtin.keymaps, '[s]earch [k]eymaps (normal mode)')
nmap('<Leader>sm', builtin.man_pages, '[s]earch [m]an pages')
nmap('<Leader>st', builtin.treesitter, '[s]earch [t]reesitter')
nmap('<Leader>sw', builtin.grep_string, '[s]earch [w]ord under cursor')
nmap('<Leader>/', builtin.current_buffer_fuzzy_find, '[s]earch [b]uffer')
-- Doesn't work with plain `builtin.find_files({ cwd = … })` because that's already a function call,
-- ie. it's return value, which is not callable. The solution below is callable.
nmap('<Leader>en', function()
  builtin.find_files({ cwd = '~/.config/nvim' })
end, '[e]dit [n]eovim')

-- ─── Git ──────────
nmap('<Leader>tgs', builtin.git_status, '[t]elescope [g]it [s]tatus')
nmap('<Leader>gb', builtin.git_bcommits, '[g]it Commits including current [b]uffer')
