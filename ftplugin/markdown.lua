vim.o.conceallevel = 2
vim.o.tabstop = 2
vim.o.shiftwidth = 2

local colors = require("kanagawa.colors").setup()
local cp = colors.palette
-- local purple = '#bb55bb' -- '#993399'
local purple = '#aa44aa'

local highlight = vim.api.nvim_set_hl
-- Colors for **bold** and *italic* text
highlight(0, "htmlBold", { fg = cp.autumnRed, bold = true })
highlight(0, 'htmlItalic', { fg = cp.roninYellow, italic = true })

highlight(0, 'my_mkdCode', { fg = purple, bold = true }) -- #993399
highlight(0, 'mkdCode', { link = 'my_mkdCode' })
highlight(0, 'mkdCodeDelimiter', { link = 'my_mkdCode' })

-- Sometimes, Neovim doesn't indent as I like and I feel that this option helps
vim.opt.autoindent = false

-- ─── Mappings (esp. for my Wiki) ──────────
-- Open help command enclosed in `` in new tab, ie. `h lua-guide`
vim.keymap.set('n', '<C-h>', '"hyi`:tab <C-r>h<CR>', { desc = 'Open help page reference in Wiki' })


-- ─── User Commands (esp. for my Wiki) ──────────
-- When I switched from Zim-Wiki to Vimwiki, my Zim-Wiki pages were not properly transformed into Markdown syntax. This User command does some post processing.
local user_command = vim.api.nvim_create_user_command
user_command('CorrectMD', 'set hlsearch | %s/` \\(.\\{-}\\)`/ `\\1`/gc', {
    desc = 'WORD` CODE` -> WORD `CODE`',
})


-- ─── Spellchecking ────────────────────
-- Copied from ftplugin/tex_vimtex.lua
-- Activate spellchecking
-- Correct misspelled words with the first proposed word.
vim.opt.spell = true
vim.opt.spelllang = { "de", "en_us" }
-- I had to download the German spell files to make spell checking work (for German)
vim.opt.spellfile = { "/home/philipp/.config/nvim/spell/en.utf-8.add", "/home/philipp/.config/nvim/spell/de.utf-8.add" }
-- vim.opt.spelloptions = { "camel" } -- Spellchecking on CamelCase words

-- Correct misspelled words with the first proposed word.
vim.api.nvim_set_keymap("i", "<C-l>", "<C-g>u<ESC>[s1z=`]a<C-g>u", { noremap = true })


-- ─── Autocommands ──────────
-- Disable highlighting after "<" (less than) or ">"; I don't need HTML highlighting
-- s. [1] for further solutions
--[1] https://github.com/preservim/vim-markdown/issues?q=disable+html+highlight
-- There is also 'BufReadPost'
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = vim.api.nvim_create_augroup('clear-htmlTag', { clear = true }),
    pattern = '*.md',
    command = 'syntax clear htmlTag | syntax clear htmlError',
    desc = 'Clear highlighting for htmlTag, htmlError in Markdown files'
})
-- vim.cmd [[ syn region htmlTag start=+<[^/]+ end=+>+ fold oneline contains=htmlTagN,htmlString,htmlArg,htmlValue,htmlTagError,htmlEvent,htmlCssDefinition,@htmlPreproc,@htmlArgCluster ]]

-- Sometimes, in README.md files a colorcolumn makes sense to avoid long one line comments in code blocks which cause horizontal scrolling
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = vim.api.nvim_create_augroup('set-colorcolumn-README.md', { clear = true }),
    pattern = 'README.md',
    command = 'set colorcolumn=70',
    desc = 'Enable colorcolumn for proper line length, especially on GitHub'
})
