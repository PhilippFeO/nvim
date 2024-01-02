--[[
╭──────────╮
│ init.lua │
╰──────────╯

Adapted configuration of https://github.com/nvim-lua/kickstart.nvim

I moved some contents into (list by far not complete)
  ./after/plugin/*.lua (<require(…).setup(…)> for some plugins)
  ./lua/*.lua  Everything here can be required directly (no path needed)
  lua/lazy/ Stuff for loading plugins initially (setup is done somewhere else)
]]

--  Must happen before plugins are required (otherwise wrong leader will be used)
--  Setting <Leader> (not necessarily <LocalLeader>) before plugins are required by lazy.nvim.
--  Otherwise wrong <Leader> is used.
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

--  You can configure plugins using the `config` key.
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({

  {
    'PhilippFeO/telescope-filelinks.nvim',
    -- `dev = true` implies using the local version of the plugin
    -- location specified via `dev.path` in `opts` parameter (s. below)
    dev = true,
    branch = 'prepend_to_link',
  },

  {
    'PhilippFeO/telescope-link-headings.nvim',
    -- `dev = true` implies using the local version of the plugin
    -- location specified via `dev.path` in `opts` parameter (s. below)
    dev = true,
    branch = 'master',
  },

  'nvim-tree/nvim-web-devicons', -- TODO: onsails/lspkind.nvim  <13-03-2023> --
  'numToStr/Comment.nvim',       -- check ./after/plugin/comment.lua for setup and mechanics
  'windwp/nvim-autopairs',       -- TODO: remove keymap for parentheses and quotation marks

  {
    'preservim/vim-markdown',
    init = function()
      vim.g.vim_markdown_conceal = true
      vim.g.vim_markdown_folding_disabled = true
      vim.g.vim_markdown_toc_autofit = true   -- :Toc, :Tocv, :Toct
      vim.g.vim_markdown_strikethrough = true -- two ~ for strikethrough
      vim.g.vim_markdown_autowrite = true     -- write when following link
      vim.g.vim_markdown_follow_anchor = true -- follow anchored links
      vim.g.vim_markdown_auto_insert_bullets = 0
      vim.g.vim_markdown_new_list_item_indent = 0
    end,
  },

  -- Becomes active after `:h timeoutlen`
  {
    'folke/which-key.nvim',
    opts = {
      disable = {
        filetypes = { "TelescopePrompt" },
      },
    }
  },

  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
    init = function()
      -- Somehow nvim started to set `tabstop` to 8 in .tex files.
      -- This option disables the vim-sleuth plugin for .tex files, `tabstop` is now 4 again.
      vim.g.sleuth_tex_heuristics = false
      -- Otherwise inconsistencies emerge because I manually set tabstop=2 in ftplugin/markdown.lua
      vim.g.sleuth_markdown_heuristics = false
    end,
  },

  {
    'lervag/vimtex',
    lazy = false -- VimTeX must not be lazy loaded.
  },
  {
    'lervag/wiki.vim',
    -- Man muss wiki <leader>ww am besten im Verzeichnis selbst aufrufen
    -- Ansonsten wird irgndwie das Arbeitsverzeichnis für das wiki auf dieses Startverzeichnis gesetzt und telescope funktioniert nicht. Macht aber keinen Unterschied, wenn man init-test.lua verwendet.
    init = function()
      vim.g.wiki_root = '~/wiki'
      vim.g.wiki_index_name = 'Notizen'
      vim.g.wiki_filetypes = { 'md' }
      vim.g.wiki_link_extension = '.md'
      vim.g.wiki_link_target_type = 'md'
      vim.g.wiki_global_load = false
      vim.g.wiki_write_on_nav = true
      vim.g.wiki_tag_scan_num_lines = 5
    end,
  },

  -- ─── Snippets ──────────
  require('lazy.ultisnips'),
  {
    'honza/vim-snippets',
  },
  {
    -- ultisnips sources for LSP
    'quangnguyen30192/cmp-nvim-ultisnips',
    init = function() require("cmp_nvim_ultisnips").setup({}) end,
  },


  require('lazy.nvim-lspconfig-mason'),
  require('lazy.nvim-cmp'),
  require('lazy.git-plugins'),
  require('lazy.kanagawa'),
  require('lazy.lualine'),
  require('lazy.treesitter'),
  require('lazy.telescope'),
  require('lazy.telescope-fzf-native'),
  require('lazy.autoformat'),

  -- note: next step on your neovim journey: add/configure additional "plugins" for kickstart
  --       these are some example plugins that i've included in the kickstart repository.
  --       uncomment any of the lines below to enable them.
  -- require 'plugins.lazy.debug', -- Already configured for python but better check it again

  -- note: the import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    you can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    for additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  --
  --    an additional note is that if you only copied in the `init.lua`, you can just comment this line
  --    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
  -- { import = 'custom.plugins' },
}, {
  dev = { path = '~/dotfiles/nvim/projects/' }
})


-- setup neovim lua configuration
require('neodev').setup()

-- some plugins, fi. UltiSnips, need python and a python interpreter with the
-- "pynvim" module (installation: python3 -m pip install --user --upgrade pynvim)
-- should now work with virtual envs flawlessly
-- (s. :help provider-python & further information in my personal wiki, because i havn't understood)
-- the mechanic completely
vim.g.python3_host_prog = '/usr/bin/python3'


-- ─── Language ──────────
vim.api.nvim_exec('language en_US.utf8', true)

-- ─── :help in new tab ──────────
vim.cmd.cabbrev('helpt', 'tab help')
vim.cmd.cabbrev('thelp', 'tab help')
vim.cmd.cabbrev('ht', 'tab help')

-- ─── Highlight on yank ──────────
-- see `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('yankhighlight', { clear = true })
vim.api.nvim_create_autocmd('textyankpost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- diagnostic keymaps
-- TODO: Move to a better lsp-related location <19-12-2023>
vim.keymap.set('n', '<Leader>dk', vim.diagnostic.goto_prev, { desc = "LSP: Go to previous diagnostic message" })
vim.keymap.set('n', '<Leader>dj', vim.diagnostic.goto_next, { desc = "LSP: Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "LSP: Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "LSP: Open diagnostics list" })

-- the line beneath this is called `modeline`. see `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
