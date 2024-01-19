--[[
  I disabled every luasnip related line of code. Search for "luasnip" to reverse this step after installing luasnip.
--]]

-- it also possible to use Unicode symbols like 📂️, 🚀️, etc.
local kind_icons = {
  Class = "ﴯ",
  Color = "",
  Constant = "",
  Constructor = "󰎔", -- "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Keyword = "",
  Method = "",
  Module = "",
  Operator = "",
  Property = "ﰠ",
  Reference = "",
  Snippet = "", -- ✂️
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "x" -- ""
}


-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- nvim-cmp setup
local cmp = require 'cmp'

-- local luasnip = require 'ultisnips'
--luasnip.config.setup {}

cmp.setup {
  -- enable snippet enginge. nvim-cmp needs a snippet enginge to work properly, even if no snippets are defined/used.
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    -- <C-n> and <C-p> to move between next and previous item
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        -- elseif luasnip.expand_or_jumpable() then -- kickstart.nvim original...
        --   luasnip.expand_or_jump()
        -- ...UltiSnips version
      elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() then
        vim.fn["UltiSnips#ExpandSnippetOrJump."]()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
        -- elseif luasnip.jumpable(-1) then -- kickstart.nvim original...
        --   luasnip.jump(-1)
        -- ...UltiSnips version
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
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
    { name = 'nvim_lua' },
    {
      name = 'path',
      option = { trailing_slash = true },
    },
    {
      name = 'buffer',
      keyword_length = 5 -- Start completion for words in buffer after N typed characters, so there is less visual clutter, when typing short words
    },
    -- { name = 'ingredients', options = { documentation_string = '%s\n%s\n%s', lorem = 'ipsum' } },
    { name = 'ingredients' },
  },

  formatting = {
    format = function(entry, vim_item)
      local lspkind_ok, lspkind = pcall(require, "lspkind")
      if not lspkind_ok then
        -- From kind_icons array
        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        -- Source description
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          ultisnip = "[UltiS]",
          nvim_lua = "[API]",
          path = "[Path]",
          buffer = "[Buf]",
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

  experimental = {
    -- native_menu = false,
    ghost_text = false -- conflicts with Copilot or Codeium
    --    ghost_text = {
    --      hl_group = 'NameOfHighlightGroup'
    --    }
  },
}
