-- it also possible to use Unicode symbols like 📂️, 🚀️, etc.
local kind_icons = {
  Class = "ﴯ",
  Color = " ",
  Constant = "",
  Constructor = "󰎔 ", -- "",
  Enum = " ",
  EnumMember = " ",
  Event = "",
  Field = "",
  File = "",
  Folder = " ",
  Function = "",
  Interface = " ",
  Keyword = " ",
  Method = " ",
  Module = " ",
  Operator = " ",
  Property = "ﰠ",
  Reference = " ",
  Snippet = " ", -- ✂️
  Struct = " ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = "x" -- ""
}

local cmp = require 'cmp'


-- TODO: Herausfinden, was damit gemeint war/ist <19-01-2024>
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


-- `()` were not inserted automatically when completing a function/method. This is fixed with code snippet below.
-- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#add-parentheses-after-selecting-function-or-method-item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Completion for Command line, ie :-command mode.
-- Very similar to default but activates automatically and has fuzzy finding capabilities
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      -- option = {
      --   ignore_cmds = { 'Man', '!' }
      -- }
    }
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

---Helper function to format `h complete-items`. Indicate the LSP name for a 'nvim_lsp' source, ie. don't show "[LSP]" (before) but "[lua_ls]".
---@param e cmp.Entry
---@param ci vim.CompletedItem
---@see Help `complete-items`
local function set_menu(e, ci)
  if e.source.name == 'nvim_lsp' then
    local aliases = { basedpyright = 'BPR', pylsp = 'PYL' }
    ci.menu = '[' .. (aliases[e.source.source.client.name] or e.source.source.client.name) .. ']'
  else
    ci.menu = ({
      git           = '[GIT]',
      ultisnip      = '[SNIP]',
      nvim_lua      = '[API]',
      path          = '[Path]',
      buffer        = '[Buf]',
      cmp_csv       = '[CSV]',
      cmp_help_tags = '[H]',
      -- ['vim-dadbod-completion'] = '[DB]',
    })[e.source.name]
  end
end


cmp.setup({
  -- enable snippet enginge. nvim-cmp needs a snippet enginge to work properly, even if no snippets are defined/used.
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    -- complete() shows the completion menu/list
    -- Useful, when
    --    - dismissed the menu and want it back without retyping
    --    - A source requires explicit triggering (some LSP servers)
    --    - You want completion inside a string/comment where it's otherwise suppressed
    ['<C-Space>'] = cmp.mapping.complete {},
    -- Executes completion of selected item
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    -- Assumption: Only relevant if LSP provides snippets
    -- <C-n> and <C-p> to move between next and previous item
    ['<C-n>'] = cmp.mapping(
      function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() then
          vim.fn["UltiSnips#ExpandSnippetOrJump."]()
        else
          fallback()
        end
      end, { 'i', 's' }
    ),
    ['<C-p>'] = cmp.mapping(
      function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.fn["UltiSnips#CanJumpBackwards"]() then
          vim.fn["UltiSnips#JumpBackwards"]()
        else
          fallback()
        end
      end, { 'i', 's' }
    ),
  },

  -- Ordering matters, i.e. in completion menu nvim_lsp proposals come before Snippets, before path , ...
  -- This behavior can also be achieved by the <priority> key
  -- Don't forget to add a 'menu' entry below in 'formatting.format'
  sources = {
    { name = 'nvim_lua' },
    { name = 'ultisnips' },
    { name = 'nvim_lsp' },
    { name = 'lazydev' },
    {
      name = 'path',
      -- Doesnt work or I dont understand how it works
      trigger_characters = { '|' },
      option = {
        -- Doesnt work or I dont understand how it works
        pathMapings = {
          ['/src'] = '${folder}/src',
          -- ['/'] = '${folder}/src/public/',
          -- ['~@'] = '${folder}/src',
          -- ['/images'] = '${folder}/src/images',
          -- ['/components'] = '${folder}/src/components',
        },
        trailing_slash = true
      },
    },
    { name = 'git' },
    {
      name = 'buffer',
      -- Start completion for words in buffer after N typed characters, so there is less visual clutter, when typing short words
      keyword_length = 5
    },
    { name = 'cmp_csv' },
    {
      name = 'cmp_help_tags',
      -- TODO: What do `h keyword_pattern` and `h trigger_characters`? <01-02-2024>
      keyword_length = 5
    },
  },

  formatting = {
    -- fields = { 'abbr', 'icon', 'kind', 'menu' },
    format = function(entry, vim_item)
      local lspkind_ok, lspkind = pcall(require, "lspkind")
      -- Fallback if lskind is not installed
      -- 2026-06-08: lspkind is NOT installed, one plugin less.
      if not lspkind_ok then
        vim_item.icon = kind_icons[vim_item.kind]
        set_menu(entry, vim_item)
        return vim_item
      else
        -- ╭──────────────────────────────────────╮
        -- │ Currently, lspkind is NOT installed! │
        -- ╰──────────────────────────────────────╯
        -- I dont see any difference in comparison to my manual approach.
        return lspkind.cmp_format({
          maxwidth = {
            -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- can also be a function to dynamically calculate max width such as
            -- menu = function() return math.floor(0.45 * vim.o.columns) end,
            menu = 50,              -- leading text (labelDetails)
            abbr = 50,              -- actual suggestion item
          },
          ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true, -- show labelDetails in menu. Disabled by default

          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          before = function(_entry, _vim_item)
            if _vim_item.kind == 'Variable' then
              -- Change Icon (I prefere 'x' over \alpha)
              _vim_item.icon = kind_icons[_vim_item.kind]
            end
            set_menu(_entry, _vim_item)
            return _vim_item
          end,
        })(entry, vim_item)
      end
    end
  },

  -- Menu direction can be changed, in case cursor is at the bottom or in command line,
  --    > https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#custom-menu-direction
  view = {
    entries = "custom", -- can be "custom", "wildmenu" or "native"
    selection_order = 'near_cursor'
  },

  window = {
    documentation = {
      -- `h nvim_open_win()`
      border = require('utils').border
    },
    -- completion = {
    --   max_height = 8,
    -- }
  },

  experimental = {
    -- native_menu = false,
    ghost_text = false -- conflicts with Copilot or Codeium
    --    ghost_text = {
    --      hl_group = 'NameOfHighlightGroup'
    --    }
  },
  -- Default: everything is false, as I prefere it.
  -- matching = …
})


-- Filetype speific completions must be handled via `filetype` function
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})
require("cmp_git").setup({})


-- SQL completion (vim-dadbod-completion)
cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
  sources = {
    { name = 'vim-dadbod-completion' },
    { name = 'buffer' },
  },
  formatting = {
    format = function(entry, vim_item)
      if vim_item ~= nil then
        vim_item.menu = '[DB]'
        return vim_item
      end
    end
  }
})
