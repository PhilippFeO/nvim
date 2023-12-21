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
    prompt_prefix = '🔭 ',
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

-- ─── [f]ind keymaps ──────────
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[f]ind existing [b]uffers' })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[f]ind [f]iles' })

-- ─── [s]earch keymaps ──────────
vim.keymap.set('n', '<Leader>sa', builtin.autocommands, { desc = '[s]earch [a]utocommands' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[s]earch project with [g]rep' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp' })
vim.keymap.set('n', "<leader>sk", builtin.keymaps, { desc = "[s]earch [k]eymaps (normal mode)" })
vim.keymap.set('n', '<Leader>sm', builtin.man_pages, { desc = '[s]earch [m]an pages' })
vim.keymap.set('n', '<leader>st', builtin.treesitter, { desc = '[s]earch [t]reesitter' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[s]earch [w]ord under cursor' })
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '[s]earch [b]uffer' })


-- Telescope extensions
-- ────────────────────
-- ─── filelinks ──────────
require('telescope').load_extension('filelinks')
local filelinks = require('telescope').extensions['filelinks']
filelinks.setup({
  working_dir = '~/wiki/',
  format_string = '[  %s](/%s)',
  prompt_title = 'Wiki Files'
})
vim.keymap.set('n', '<Leader>lw', filelinks.make_filelink, { desc = '[l]ink to [w]iki page' })
vim.keymap.set('i', '<C-k>', filelinks.make_filelink, { desc = ':Telescope filelinks make_filelink' })

vim.keymap.set('n', '<Leader>lf', function()
  filelinks.make_filelink({
    working_dir = '/home/philipp/',
    format_string = '[%s](%s)',
    remove_extension = false,
    prompt_title = 'Files under /home/philipp/'
  })
end, { desc = '[l]ink to [f]ile in $HOME' })

vim.keymap.set('n', '<Leader>li', function()
  filelinks.make_filelink({
    format_string = '  ![%s](%s)',
    remove_extension = false,
    first_upper = false,
    prepend_to_link = "~/wiki/",
    find_command = { "rg", "-g", "**.png", "--files", "--color", "never" }
  })
end, { desc = '[l]ink to [i]mage in ~/wiki/' })

-- ─── link_headings ──────────
-- require('telescope').load_extension('link_headings')
-- local link_headings = require('telescope').extensions['link_headings']
-- link_headings.setup({
--   working_dir = '~/wiki/',
--   format_picker_entry = '%s   (%s)'
-- })
-- vim.keymap.set('n', '<Leader>la', link_headings.link_heading, { desc = '[l]ink to he[a]ding' })
