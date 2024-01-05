-- ╭─────────────────────────╮
-- │ Telescope Configuration │
-- ╰─────────────────────────╯
-- See `:help telescope`

require('telescope').setup { -- :h telescope.setup()
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = true,
        ['<C-d>'] = true,
        -- ["<C-h>"] = "which_key",
      },
    },
    prompt_prefix = '  ',
    path_display = { 'shorten', shorten = 4 },
    layout_config = { preview_width = 0.5 },
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
    desc = ' Tel: ' .. desc
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
nmap('<Leader>fb', builtin.buffers, '[f]ind existing [b]uffers')
nmap('<Leader>ff', builtin.find_files, '[f]ind [f]iles')

-- ─── [s]earch keymaps ──────────
nmap('<Leader>sa', builtin.autocommands, '[s]earch [a]utocommands')
nmap('<Leader>sd', builtin.diagnostics, '[s]earch [d]iagnostics')
nmap('<Leader>sg', builtin.live_grep, '[s]earch project with [g]rep')
nmap('<Leader>sh', builtin.help_tags, '[s]earch [h]elp')
nmap('<Leader>sk', builtin.keymaps, '[s]earch [k]eymaps (normal mode)')
nmap('<Leader>sm', builtin.man_pages, '[s]earch [m]an pages')
nmap('<Leader>st', builtin.treesitter, '[s]earch [t]reesitter')
nmap('<Leader>sw', builtin.grep_string, '[s]earch [w]ord under cursor')
nmap('<Leader>/', builtin.current_buffer_fuzzy_find, '[s]earch [b]uffer')

-- ─── Git ──────────
nmap('gs', builtin.git_status, '[g]it [s]tatus')
