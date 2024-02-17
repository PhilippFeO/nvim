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
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ["kj"] = "close",
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
nmap('<Leader>sf', builtin.current_buffer_fuzzy_find, '[s]earch current [f]ile')
nmap('<Leader>sg', builtin.live_grep, '[s]earch project with [g]rep')
-- Keymap for help_tags defined below
-- nmap('<Leader>sh', builtin.help_tags, '[s]earch [h]elp')
nmap('<Leader>sk', builtin.keymaps, '[s]earch [k]eymaps (normal mode)')
nmap('<Leader>sm', builtin.man_pages, '[s]earch [m]an pages')
nmap('<Leader>st', builtin.treesitter, '[s]earch [t]reesitter')
nmap('<Leader>sw', builtin.grep_string, '[s]earch [w]ord under cursor')

-- Open help tags in vertical split on default.
-- Code of `h attach_mappings` copied from `h telescope.builtin.help_tags`.
-- Only if block at the end was changed.
-- Procedure found on 'https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#actions'
local action_state = require "telescope.actions.state"
local action_set = require 'telescope.actions.set'
local utils = require "telescope.utils"
local my_help_tags = function()
  local opts = {
    attach_mappings = function(prompt_bufnr)
      action_set.select:replace(function(_, cmd)
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.help_tags"
          return
        end

        actions.close(prompt_bufnr)
        print(cmd)
        if cmd == "default" then
          vim.cmd("vert help " .. selection.value)
        elseif cmd == "horizontal" then -- <C-x> opens horizontally
          vim.cmd("help " .. selection.value)
        elseif cmd == "tab" then        -- <C-t> opens in new tab
          vim.cmd("tab help " .. selection.value)
        end
      end)

      return true
    end,
  }
  require('telescope.builtin').help_tags(opts)
end
nmap('<Leader>sh', my_help_tags, 'my help tags')

-- Doesn't work with plain `builtin.find_files({ cwd = … })` because that's already a function call,
-- ie. it's return value, which is not callable. The solution below is callable.
nmap('<Leader>en', function()
  builtin.find_files({ cwd = '~/.config/nvim' })
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
require('telescope').load_extension('filelinks')
local filelinks = require('telescope').extensions['filelinks']
filelinks.setup({
  working_dir = '~/wiki/',
  format_string = '  [%s](%s)',
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
