-- ╭─────────────────────────╮
-- │ Telescope Configuration │
-- ╰─────────────────────────╯
-- See `:help telescope`

local telescope = require 'telescope'

local actions = require('telescope.actions')

telescope.setup { -- :h telescope.setup()
  extensions = {
    ["ui-select"] = {
      -- https://github.com/nvim-telescope/telescope-ui-select.nvim
      require("telescope.themes").get_dropdown {}
    }
  },
  defaults = {
    -- see `h telescope.mappings`
    -- worth reading once and a while, because options are possible
    mappings = {
      n = {
        -- There is also `send_selected_to_qflist`
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
      },
      i = {
        ['kj'] = 'close', -- equivalent to `require 'telescope.actions'.close
        ['<C-u>'] = 'results_scrolling_up',
        ['<C-d>'] = 'results_scrolling_down',
        ['<TAB>'] = 'select_tab',
        ['<M-t>'] = 'select_tab',
        ['<M-v>'] = 'select_vertical',
        ['<M-x>'] = 'select_horizontal',
      },
    },
    prompt_prefix = '  ',
    selection_caret = '  ',
    entry_prefix = '   ',
    layout_strategy = 'vertical',
    layout_config = {
      horizontal = {
        preview_width = 0.6,
        prompt_position = 'top'
      },
      vertical = {
        prompt_position = 'top',
        -- mirror = true,
      }
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


require("telescope").load_extension("ui-select")

-- https://github.com/nvim-telescope/telescope-dap.nvim
-- Picker for DAP, fi. Configurations
telescope.load_extension('dap')

-- Enable telescope fzf native, if installed
pcall(telescope.load_extension, 'fzf')

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
nmap('<Leader>f', function()
  -- In 'kursverwaltung' lies a `.ignore` file, which defines directories to be ignored, fi. `*migrations*`
  ---@diagnostic disable-next-line: param-type-mismatch
  if string.find(vim.uv.cwd(), 'grocery') then
    builtin.find_files({
      -- .gitignore still active
      search_dirs = {
        vim.uv.cwd(),
        vim.uv.cwd() .. '/recipes/',
        vim.uv.cwd() .. '/misc/',
        vim.uv.cwd() .. '/.resources/',
      }
    })
  else
    builtin.find_files()
  end
end
, 'find [f]iles')

-- ─── [s]earch keymaps ──────────
nmap('<Leader>sa', builtin.autocommands, '[s]earch [a]utocommands')
nmap('<Leader>sb', builtin.buffers, '[s]earch existing [b]uffers')
nmap('<Leader>sC', builtin.commands, '[s]earch [C]ommands')
nmap('<Leader>sd', builtin.diagnostics, '[s]earch [d]iagnostics')
nmap('<Leader>sf', builtin.current_buffer_fuzzy_find, '[s]earch current [f]ile')
nmap('<Leader>sg', builtin.live_grep, '[s]earch project with [g]rep')
nmap('<Leader>sk', builtin.keymaps, '[s]earch [k]eymaps (normal mode)')
nmap('<Leader>sq', builtin.quickfix, '[s]earch [q]uickfix list')
nmap('<Leader>st', builtin.treesitter, '[s]earch [t]reesitter')
nmap('<Leader>sw', builtin.grep_string, '[s]earch [w]ord under cursor')
nmap('<Leader>gf', require 'telescope-live-filetype-grep'.live_filetype_grep, 'live [g]rep with [f]iletype')

-- Tweaked builtins to open in vertical split on default
nmap('<Leader>sh', require('telescope_utils').vsplit_help_tags, '[s]earch [h]elp')
nmap('<Leader>sm', require('telescope_utils').tab_man_pages, '[s]earch [m]an pages')

-- Doesn't work with plain `builtin.find_files({ cwd = … })` because that's already a function call,
-- ie. it's return value, which is not callable. The solution below is callable.
nmap('<Leader>en', function()
  builtin.find_files({ cwd = vim.fn.stdpath('config') })
end, '[e]dit [n]eovim')

-- ─── Git ──────────
nmap('<Leader>tgs', builtin.git_status, '[t]elescope [g]it [s]tatus')
nmap('<Leader>gb', builtin.git_bcommits, '[g]it Commits including current [b]uffer')

-- ─── wiki.vim ──────────
nmap('<Leader>wt', '<Plug>(wiki-tags)', 'search [w]iki [t]ags')


-- Telescope extensions
-- ────────────────────
-- Interesting extensions:
--    - live_grep_args: Options for ripgrep in picker, fi. `-t md` to search only markdown files
--    - advanced_git_search: Better git search, afaik you select the file (via telescope) and then all commits affecting this file opens to be searched again
--        - evtl. ähnlich zu `builtin.git_bcommits`

-- ─── filelinks ──────────
telescope.load_extension('filelinks')
local filelinks = telescope.extensions['filelinks']
filelinks.setup({
  working_dir = '~/wiki/',
  format_string = '  [%s](%s)',
  prompt_title = 'Wiki Files'
})
vim.keymap.set('n', '<Leader>lw', function() filelinks.make_filelink({}) end,
  { desc = prepend_desc('[l]ink to [w]iki page') })
-- TODO: remap of keymaps? <21-12-2023>
vim.keymap.set('i', '<C-k>', function() filelinks.make_filelink({}) end, { desc = prepend_desc('[l]ink to [w]iki page') })

vim.keymap.set('n', '<Leader>lf', function()
  filelinks.make_filelink({
    working_dir = vim.fn.expand('~'),
    format_string = '[%s](%s)',
    remove_extension = false,
    prompt_title = 'Files in $HOME: ' .. vim.fn.expand('~')
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
-- telescope.load_extension('link_headings')
-- local link_headings = telescope.extensions['link_headings']
-- link_headings.setup({
--   working_dir = '~/wiki/',
--   format_picker_entry = '%s   (%s)'
-- })
-- vim.keymap.set('n', '<Leader>la', link_headings.link_heading, { desc = '[l]ink to he[a]ding' })
