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
    prompt_prefix = ' ',
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
nmap('<leader>fb', builtin.buffers, '[f]ind existing [b]uffers')
nmap('<leader>ff', builtin.find_files, '[f]ind [f]iles')

-- ─── [s]earch keymaps ──────────
nmap('<Leader>sa', builtin.autocommands, '[s]earch [a]utocommands')
nmap('<leader>sd', builtin.diagnostics, '[s]earch [d]iagnostics')
nmap('<leader>sg', builtin.live_grep, '[s]earch project with [g]rep')
nmap('<leader>sh', builtin.help_tags, '[s]earch [h]elp')
nmap('<leader>sk', builtin.keymaps, '[s]earch [k]eymaps (normal mode)')
nmap('<Leader>sm', builtin.man_pages, '[s]earch [m]an pages')
nmap('<leader>st', builtin.treesitter, '[s]earch [t]reesitter')
nmap('<leader>sw', builtin.grep_string, '[s]earch [w]ord under cursor')
nmap('<leader>/', builtin.current_buffer_fuzzy_find, '[s]earch [b]uffer')

-- ─── Git ──────────
nmap('gs', builtin.git_status, '[g]it [s]tatus')

-- Telescope extensions
-- ────────────────────
-- ─── filelinks ──────────
require('telescope').load_extension('filelinks')
local filelinks = require('telescope').extensions['filelinks']
filelinks.setup({
  working_dir = '~/wiki/',
  format_string = '[  %s](%s)',
  prompt_title = 'Wiki Files'
})
vim.keymap.set('n', '<Leader>lw', filelinks.make_filelink, { desc = prepend_desc('[l]ink to [w]iki page') })
-- TODO: remap of keymaps? <21-12-2023>
vim.keymap.set('i', '<C-k>', filelinks.make_filelink, { desc = prepend_desc('[l]ink to [w]iki page') })

vim.keymap.set('n', '<Leader>lf', function()
  filelinks.make_filelink({
    working_dir = '/home/philipp/',
    format_string = '[%s](%s)',
    remove_extension = false,
    prompt_title = 'Files in $HOME'
  })
end, { desc = prepend_desc('[l]ink to [f]ile in $HOME') })

vim.keymap.set('n', '<Leader>li', function()
  filelinks.make_filelink({
    format_string = '  ![%s](%s)',
    remove_extension = false,
    first_upper = false,
    prepend_to_link = "~/wiki/",
    find_command = { "rg", "-g", "**.png", "--files", "--color", "never" }
  })
end, { desc = prepend_desc('[l]ink to [i]mage in ~/wiki/') })

-- ─── link_headings ──────────
-- require('telescope').load_extension('link_headings')
-- local link_headings = require('telescope').extensions['link_headings']
-- link_headings.setup({
--   working_dir = '~/wiki/',
--   format_picker_entry = '%s   (%s)'
-- })
-- vim.keymap.set('n', '<Leader>la', link_headings.link_heading, { desc = '[l]ink to he[a]ding' })
