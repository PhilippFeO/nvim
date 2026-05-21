local parsers = { 'bash', 'diff', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'python' }
require('nvim-treesitter').install(parsers)


vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'bash', 'lua', 'markdown', 'markdown_inline', 'python', 'query', 'vimdoc', 'vim', 'luadoc' },
  callback = function()
    -- syntax highlighting, provided by Neovim
    vim.treesitter.start()
    -- folds, provided by Neovim
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldmethod = 'expr'
    -- indentation, provided by nvim-treesitter
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

vim.treesitter.language.register('markdown', 'octo')

-- Default values in `h nvim-treesitter-context`
local tc = require 'treesitter-context'
tc.setup {
  multiline_threshold = 1, -- Maximum number of lines to show for a single context
  mode = 'cursor',
  -- max_lines = 5,
  -- trim_scope = 'outer',
}
tc.toggle()

-- incremental_selection = {
--   enable = true,
--   keymaps = {
--     init_selection = '<C-space>',
--     -- Default mapping: van … an … an
--     -- node_incremental = '<C-space>',
--     scope_incremental = '<c-s>',
--     -- Default mapping: vin … in … in
--     -- node_decremental = '<A-space>',
--   },
-- },
-- textobjects = {
--   select = {
--     enable = true,
--     lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
--     keymaps = {
--       -- You can use the capture groups defined in textobjects.scm
--       ['aa'] = '@parameter.outer',
--       ['ia'] = '@parameter.inner',
--       ['af'] = '@function.outer',
--       ['if'] = '@function.inner',
--       ['ac'] = '@class.outer',
--       ['ic'] = '@class.inner',
--     },
--   },
--   move = {
--     enable = true,
--     set_jumps = true, -- whether to set jumps in the jumplist
--     goto_next_start = {
--       [']m'] = '@function.outer',
--       [']]'] = '@class.outer',
--     },
--     goto_next_end = {
--       [']M'] = '@function.outer',
--       [']['] = '@class.outer',
--     },
--     goto_previous_start = {
--       ['[m'] = '@function.outer',
--       ['[['] = '@class.outer',
--     },
--     goto_previous_end = {
--       ['[M'] = '@function.outer',
--       ['[]'] = '@class.outer',
--     },
--   },
--   swap = {
--     enable = true,
--     swap_next = {
--       ['<leader>a'] = '@parameter.inner',
--     },
--     swap_previous = {
--       ['<leader>A'] = '@parameter.inner',
--     },
--   },
