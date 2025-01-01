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

-- make 'require' work on 'after/plugin/' files
-- fi. necessary to pass a config to 'dap-python.test_method()'
local home_dir = os.getenv("HOME")
package.path = home_dir .. "/.config/nvim/after/plugin/?.lua;" .. package.path

local start_idx, _ = string.find(vim.fn.hostname(), 'dlr.de')
if start_idx then
  DLR_Machine = true
else
  DLR_Machine = false
end

--  Must happen before plugins are required (otherwise wrong leader will be used)
--  Setting <Leader> (not necessarily <LocalLeader>) before plugins are required by lazy.nvim.
--  Otherwise wrong <Leader> is used.
vim.g.mapleader = ' '
vim.g.maplocalleader = 'ö'

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

  {
    'PhilippFeO/telescope-link-headings.nvim',
    -- `dev = true` implies using the local version of the plugin
    -- location specified via `dev.path` in `opts` parameter (s. below)
    dev = true,
    branch = 'master',
    cond = false,
  },

  -- 'numToStr/Comment.nvim',       -- check ./after/plugin/comment.lua for setup and mechanics
  -- setup in after/plugin/lualine.lua
  'nvim-lualine/lualine.nvim',
  'nvim-tree/nvim-web-devicons', -- TODO: onsails/lspkind.nvim  <13-03-2023> --
  'windwp/nvim-autopairs',

  -- -- kanagawa colors and themes are in misc/
  -- {
  --   'norcalli/nvim-colorizer.lua',
  --   -- runs setup({})
  --   -- otherwise:
  --   --    require'colorizer'.setup()
  --   -- after require 'lazy'.setup()
  --   config = true
  -- },

  {
    'lervag/vimtex',
    lazy = false, -- VimTeX must not be lazy loaded.
    ft = { 'tex' },
  },

  -- ─── Snippets ──────────
  require 'plugins.ultisnips',
  'honza/vim-snippets',
  {
    -- ultisnips sources for LSP
    -- Ich hatte in letzter Zeit (2024-11-01) oft das Problem, dass irgendwann die Schnipsel nicht mehr funktionierten, bspw. `ilink` im Wiki oder `feat` in Git. Keine Ahnung, woran das liegt.
    'quangnguyen30192/cmp-nvim-ultisnips',
    -- Hier erhalte ich Fehler
    -- commit = 'f5c5cd6da094ef04a7d6e0bea73f71dfa5dde9bf',
    -- Hier funktioniert's
    commit = '43b69a235b2dc54db692049fe0d5cc60c6b58b4b',
    init = function() require("cmp_nvim_ultisnips").setup({}) end,
  },

  require 'plugins.octo',
  require 'plugins.gitlinker',
  require 'plugins.vim-sleuth',
  require 'plugins.wiki',
  require 'plugins.vim-markdown',
  require 'plugins.lazydev',
  require 'plugins.nvim-lspconfig-mason',
  require 'plugins.nvim-cmp',
  require 'plugins.git-plugins',
  require 'plugins.kanagawa',
  require 'plugins.treesitter',
  require 'plugins.telescope',
  require 'plugins.telescope-fzf-native',
  require 'plugins.autoformat',
  require 'plugins.debug'

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
-- require('neodev').setup({
--   library = { plugins = { "nvim-dap-ui" }, types = true },
-- })

-- some plugins, fi. UltiSnips, need python and a python interpreter with the
-- "pynvim" module (installation: python3 -m pip install --user --upgrade pynvim)
-- should now work with virtual envs flawlessly
-- (s. :help provider-python & further information in my personal wiki, because i havn't understood)
-- the mechanic completely
vim.g.python3_host_prog = '/usr/bin/python3'


-- ─── Language ──────────
vim.api.nvim_exec2('language en_US.utf8', {})


-- ─── Command shortcuts ──────────
-- Trigger by adding ' ', ie `:ht `
vim.cmd.cabbrev('tn', 'tabnew')
vim.cmd.cabbrev('qc', 'cclose')
-- :help in new tab
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
