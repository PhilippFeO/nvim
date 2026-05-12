-- I disabled every luasnip related line of code. Search for "luasnip" to reverse this step after installing luasnip.

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
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})

cmp.setup {
  -- enable snippet enginge. nvim-cmp needs a snippet enginge to work properly, even if no snippets are defined/used.
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<C-CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    -- <C-n> and <C-p> to move between next and previous item
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() then
        vim.fn["UltiSnips#ExpandSnippetOrJump."]()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["UltiSnips#CanJumpBackwards"]() then
        vim.fn["UltiSnips#JumpBackwards"]()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },

  -- Ordering matters, i.e. in completion menu nvim_lsp proposals come before luasnip, before path , ...
  -- This behavior can also be achieved by the <priority> key
  -- Don't forget to add a menu entry below
  sources = {
    { name = 'git' },
    { name = 'ultisnips' },
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'lazydev' },
    {
      name = 'path',
      option = { trailing_slash = true },
    },
    {
      name = 'buffer',
      keyword_length = 5 -- Start completion for words in buffer after N typed characters, so there is less visual clutter, when typing short words
    },
    { name = 'cmp_csv' },

    { name = 'cmp_help_tags',
      -- TODO: What do `h keyword_pattern` and `h trigger_characters`? <01-02-2024>
      keyword_length = 5
    },
  },


  formatting = {
    format = function(entry, vim_item)
      local lspkind_ok, lspkind = pcall(require, "lspkind")
      if not lspkind_ok then
        -- From kind_icons array
        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        -- Source description
        vim_item.menu = ({
          git = "[GIT]",
          ultisnip = "[UltiS]",
          nvim_lua = "[API]",
          nvim_lsp = "[N-LSP]",
          path = "[Path]",
          buffer = "[Buf]",
          cmp_csv = "[CSV]",
          cmp_help_tags = "[H]"
        })[entry.source.name]
        return vim_item
      else
        -- From lspkind
        return lspkind.cmp_format()
      end
    end
  },

  -- Menu direction can be changed, in case cursor is at the bottom or in command line,
  --    > https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#custom-menu-direction
  view = {
    entries = "custom" -- can be "custom", "wildmenu" or "native"
  },

  window = {
    documentation = {
      -- `h nvim_open_win()`
      border = require('utils').border
    }
  },

  experimental = {
    -- native_menu = false,
    ghost_text = false -- conflicts with Copilot or Codeium
    --    ghost_text = {
    --      hl_group = 'NameOfHighlightGroup'
    --    }
  },
}

require("cmp_git").setup({})
