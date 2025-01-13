vim.treesitter.language.register('markdown', 'octo')

local defaults = { 'lua', 'python', 'vim', 'vimdoc' }
if DLR_Machine then
  for _, language in ipairs({ 'cpp', 'cmake' }) do
    table.insert(defaults, language)
  end
end


-- Default values in `h nvim-treesitter-context`
require 'treesitter-context'.setup {
  multiline_threshold = 1, -- Maximum number of lines to show for a single context
  mode = 'topline',
  -- max_lines = 5,
  -- trim_scope = 'outer',
}


require('nvim-treesitter.configs').setup {
  modules = {},
  sync_install = false,

  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = defaults,

  -- treesitter and vimtex concealing collide, so I disable syntax highlighting for LaTeX
  -- s. :h vimtex-faq-treesitter
  ignore_install = { "latex", "markdown", "gitcommit", "diff", "html" },

  additional_vim_regex_highlighting = false,

  -- Autoinstall languages that are not installed. Defaults to false.
  auto_install = false,

  highlight = { enable = true },
  --indent = { enable = true, disable = { 'python' } }, -- TODO Herausfinden, was diese Zeile macht. Da ich es nicht weiß, habe ich sie auskommentiert.
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<A-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}
