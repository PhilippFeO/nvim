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

DLR_Machine = vim.fn.hostname() == "eoc-001810l.intra.dlr.de"

--  Must happen before plugins are required (otherwise wrong leader will be used)
--  Setting <Leader> (not necessarily <LocalLeader>) before plugins are required by lazy.nvim.
--  Otherwise wrong <Leader> is used.
vim.g.mapleader = ' '
vim.g.maplocalleader = 'ö'

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
    'PhilippFeO/cmp-help-tags',
    -- config = true -- runs setup({}) (with empty table)
    opts = {
      filetypes = {
        'markdown',
        'lua'
      }
    }
  },
  'PhilippFeO/telescope-filelinks.nvim',
  {
    'PhilippFeO/cmp-csv',
    opts = {
      documentation_format = '%s (Col 1)\n%s (Col 2)\n%s (Col 3)',
      csv_path = vim.fn.expand '~/programmieren/grocery-shopper/.resources/ingredient_category_url.csv',
      filetype = 'yaml',
      completion_column = 1,
      skip_rows = 0,
    },
    cond = not DLR_Machine,
  },

  -- {
  --   'PhilippFeO/telescope-link-headings.nvim',
  --   -- `dev = true` implies using the local version of the plugin
  --   -- location specified via `dev.path` in `opts` parameter (s. below)
  --   dev = true,
  --   branch = 'master',
  -- },

  'nvim-tree/nvim-web-devicons', -- TODO: onsails/lspkind.nvim  <13-03-2023> --
  'numToStr/Comment.nvim',       -- check ./after/plugin/comment.lua for setup and mechanics
  'windwp/nvim-autopairs',       -- TODO: remove keymap for parentheses and quotation marks
  { "folke/neodev.nvim", opts = {} },

  {
    'preservim/vim-markdown',
    init = function()
      vim.g.vim_markdown_conceal = true
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_folding_disabled = true
      vim.g.vim_markdown_toc_autofit = true   -- :Toc, :Tocv, :Toct
      vim.g.vim_markdown_strikethrough = true -- two ~ for strikethrough
      vim.g.vim_markdown_autowrite = true     -- write when following link
      vim.g.vim_markdown_follow_anchor = true -- follow anchored links
      vim.g.vim_markdown_auto_insert_bullets = 0
      vim.g.vim_markdown_new_list_item_indent = 0
    end,
    ft = 'markdown'
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
    lazy = false, -- VimTeX must not be lazy loaded.
    ft = { 'tex' },
  },
  {
    'lervag/wiki.vim',
    -- Man muss wiki <leader>ww am besten im Verzeichnis selbst aufrufen
    init = function()
      vim.g.tag_line_number = 2 -- NO official wiki.vim variable, I have introduced it for `wiki_utils.add_tag()`
      vim.g.wiki_root = '~/wiki'
      vim.g.wiki_index_name = 'Notizen'
      vim.g.wiki_filetypes = { 'md' }
      vim.g.wiki_link_extension = '.md'
      vim.g.wiki_link_target_type = 'md'
      vim.g.wiki_global_load = false
      vim.g.wiki_write_on_nav = true
      vim.g.wiki_tag_scan_num_lines = vim.g.tag_line_number
      vim.g.wiki_select_method = {
        tags = require("wiki.telescope").tags,
        links = require("wiki.telescope").links,
        -- pages = require("wiki.ui_select").pages,
        -- toc = require("wiki.ui_select").toc,
      }
    end,
    -- ft = { 'markdown', 'wiki' } -- doesn't work
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
  {
    -- setup in after/plugin/lualine.lua
    'nvim-lualine/lualine.nvim',
  },


  require('lazy.nvim-lspconfig-mason'),
  require('lazy.nvim-cmp'),
  require('lazy.git-plugins'),
  require('lazy.kanagawa'),
  require('lazy.treesitter'),
  require('lazy.telescope'),
  require('lazy.telescope-fzf-native'),
  require('lazy.autoformat'),

  require 'lazy.debug'

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
  dev = { path = '~/dotfiles/nvim/lua/myplugins/' }
})


-- setup neovim lua configuration
require('neodev').setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})

-- some plugins, fi. UltiSnips, need python and a python interpreter with the
-- "pynvim" module (installation: python3 -m pip install --user --upgrade pynvim)
-- should now work with virtual envs flawlessly
-- (s. :help provider-python & further information in my personal wiki, because i havn't understood)
-- the mechanic completely
vim.g.python3_host_prog = '/usr/bin/python3'


-- ─── Language ──────────
vim.api.nvim_exec2('language en_US.utf8', {})


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


-- the line beneath this is called `modeline`. see `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
