local wiki_utils = require('wiki_utils')

vim.keymap.set('n', '<A-k>', wiki_utils.add_tag, {
    buffer = true,
    desc = 'Add word under cursor as tag'
})
vim.keymap.set('n', '<A-l>', wiki_utils.filename_as_tags, {
    buffer = true,
    desc = 'Write file name as wiki tags in 2. line'
})


-- Conceal markdown formatting, fi. *italic* with italic text and no '*'
vim.o.conceallevel = 2
-- Sometimes, Neovim doesn't indent as I like and I feel that this option helps
vim.bo.autoindent = false

-- Try SidOfc/mkdx for highlighting. Has also some nice features.
--  highlights defined in after/syntax/markdown.vim

local colors = require("kanagawa.colors").setup()
local cp = colors.palette
local highlight = vim.api.nvim_set_hl

-- Colors for **bold** and *italic* text
highlight(0, "htmlBold", { fg = cp.autumnRed, bold = true })
highlight(0, 'htmlItalic', { fg = cp.roninYellow, italic = true })

highlight(0, 'my_mkdCode', { fg = cp.waveAqua2 }) -- #993399
highlight(0, 'mkdCode', { link = 'my_mkdCode' })
highlight(0, 'mkdCodeDelimiter', { link = 'my_mkdCode' })

-- Change color of the link alias in []
highlight(0, 'mkdLink', { fg = cp.oniViolet })
-- URLs not enclosed in []()
highlight(0, 'mkdInlineURL', { link = 'mkdLink' })

-- Change color of headings
-- winterRed suboptimal because it's used in Visual mode but I will probably enter this mode on H1 rarely
highlight(0, 'htmlH1', { fg = cp.sakuraPink, bg = cp.winterRed })
highlight(0, 'htmlH2', { fg = cp.lightBlue, bg = cp.waveBlue1 })
highlight(0, 'htmlH3', { fg = cp.springGreen, bg = cp.winterGreen })


-- ─── Mappings (esp. for my Wiki) ──────────
vim.keymap.set('i', '<A-c>', '<Esc>b~A', { buffer = true, desc = '[A] – Change [c]ase of current word.' })
-- Open help command enclosed in `` in new tab, ie. `h lua-guide`
-- <S-k> is consistent with navigating help (there, <S-k> opens another help page)
vim.keymap.set('n', '<S-k>', '"hyi`:tab <C-r>h<CR>', { buffer = true, desc = 'Open help page reference in Wiki' })


-- ─── Spellchecking ────────────────────
-- s. "Practical Vim" for Tips and Explanation
-- Copied from ftplugin/tex_vimtex.lua
-- Activate spellchecking
-- Correct misspelled words with the first proposed word.
vim.opt.spell = false
vim.opt.spelllang = { "de", "en_us" }
vim.opt.spellfile = {
    vim.fn.expand("~/.config/nvim/spell/de.utf-8.add"),
    vim.fn.expand("~/.config/nvim/spell/en.utf-8.add")
}
vim.keymap.set('n',
    '<Leader>d',
    '1zg',
    { desc = "Add word to German spellfile" })
-- Correct misspelled words with the first proposed word.
vim.keymap.set("i", "<C-l>", "<C-g>u<ESC>[s1z=`]a<C-g>u", { buffer = true, desc = 'Correct last misspelled word' })
vim.keymap.set('i', '<C-x><C-s>', '<C-x>s<CR>',
    { remap = true, desc = 'Correct last misspelled word on current line (Practical Vim)' })


-- ─── Autocommands ──────────
-- Disable highlighting after "<" (less than) or ">"; I don't need HTML highlighting
-- s. [1] for further solutions
--[1] https://github.com/preservim/vim-markdown/issues?q=disable+html+highlight
-- There is also 'BufReadPost'
-- Has to be done AFTER/WITH 'BufWinEnter', ie. simply executing the command in this filetype plugin doesn't work
-- TODO: Due to this html-whatever-highlight, Telescope's preview differs from my configured Markdown highlighting <28-12-2023>
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = vim.api.nvim_create_augroup('clear-htmlTag', { clear = true }),
    pattern = '*.md',
    command = 'syntax clear htmlTag | syntax clear htmlError',
    desc = 'Clear highlighting for htmlTag, htmlError in Markdown files'
})
