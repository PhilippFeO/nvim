-- Conceal markdown formatting, fi. *italic* with italic text and no '*'
vim.o.conceallevel = 2
-- vim.o.tabstop = 2
-- vim.o.shiftwidth = 2
-- Sometimes, Neovim doesn't indent as I like and I feel that this option helps
vim.opt.autoindent = false

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
-- Could also go in kanagawa's setup-function in the `overrides` sections but these highlights are only needed in markdown files, so they don't have to be overwritten each time nvim starts.
-- winterRed suboptimal because it's used in Visual mode but I will probably enter this mode on H1 rarely
highlight(0, 'htmlH1', { fg = cp.sakuraPink, bg = cp.winterRed })
highlight(0, 'htmlH2', { fg = cp.lightBlue, bg = cp.waveBlue1 })
highlight(0, 'htmlH3', { fg = cp.springGreen, bg = cp.winterGreen })


-- ─── Mappings (esp. for my Wiki) ──────────
-- Open help command enclosed in `` in new tab, ie. `h lua-guide`
-- <S-k> is consistent with navigating help (there, <S-k> opens another help page)
vim.keymap.set('n', '<S-k>', '"hyi`:tab <C-r>h<CR>', { desc = 'Open help page reference in Wiki' })


-- Write the file name, fi. 'neovim highlight groups.md' as wiki tags, ':neovim:highlight:groups:' in the second line
-- (I do/need this quite frequently while restructuring my wiki.)
vim.keymap.set('n', '<A-l>', function()
        -- expand file name macro
        local file_name_spaces = vim.fn.expand('%:t:r')
        -- replace spaces by :
        local file_name_colon = file_name_spaces:gsub(' ', ':')
        -- pre- and append :
        file_name_colon = ':' .. file_name_colon .. ':'
        -- write wiki tags
        -- start=end implies inserting, otherwise contents are overwritten
        vim.api.nvim_buf_set_lines(0, 1, 1, false, {
            file_name_colon,
            '',
        })
    end,
    { desc = 'Write file name as wiki tags in 2. line' })


-- ─── Spellchecking ────────────────────
-- Copied from ftplugin/tex_vimtex.lua
-- Activate spellchecking
-- Correct misspelled words with the first proposed word.
vim.opt.spell = false
vim.opt.spelllang = { "de", "en_us" }
-- I had to download the German spell files to make spell checking work (for German)
vim.opt.spellfile = { "/home/philipp/.config/nvim/spell/en.utf-8.add", "/home/philipp/.config/nvim/spell/de.utf-8.add" }

-- Correct misspelled words with the first proposed word.
vim.api.nvim_set_keymap("i", "<C-l>", "<C-g>u<ESC>[s1z=`]a<C-g>u", { noremap = true })


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
