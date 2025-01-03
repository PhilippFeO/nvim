-- [[ Setting options ]]
-- See `:help vim.o`

-- Both (suffixesadd, path) make `require('lazy.kanagawa')` in init.lua jumpable
-- (Naive explanation) When typing `gf`, every combination will be built. Then it is checked whether it's a file and can be opened.
-- Add suffix implicitly when using `gf`
vim.o.suffixesadd = '.lua,.py'
-- Analogous to `h suffixesadd` but for prepending
-- `.` = dir of curent file
-- `` (emtpy) = working dir
vim.o.path = vim.o.path .. './lua/,../,lua.'

vim.o.grepprg = 'rg --vimgrep --column --no-heading $*'
vim.o.grepformat = '%f:%l:%c:%m'

-- Dont show modes like -- INSERT --, becaues Lualine does
vim.opt.showmode = false

-- Make line and sign column transparent
vim.cmd.highlight("clear LineNr")
vim.cmd.highlight("clear SignColumn")

-- Set highlight on search
vim.o.hlsearch = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.o.clipboard = 'unnamedplus'

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
-- no capital letters: ignore case while searching
-- with capital letters: respect case while searching
vim.o.smartcase = true
-- Ignore case during search
-- TODO: Difference to smartcase unclear
vim.opt.ignorecase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.wrap = true
-- automatic line breaking 3 characters before right margin
--vim.g.textwidth = 20
--vim.g.wrapmargin = 3

-- Bye bye, mouse (but you can still scroll, old habits never die)
vim.opt.mouse = ""

-- Deprecated due to use of lualine
-- statusline
-- File name and relativ vertical position
--vim.opt.statusline = "%t    %p%% of %L Lines"

-- winbar; filename in upper right corner
-- s. :h statusline for formatting
--  %=  shift to the right
--  %m  idicates modified or not
--  %f  path to file
-- vim.o.winbar = "%=%m %f"

-- Fenstertitel zeigt Dateiname
vim.opt.title = true

-- relative line numbering
vim.opt.number = true -- left align current line number
vim.opt.relativenumber = true

-- block cursor in Insert mode (default is a | as usual)
vim.opt.guicursor = "i-ci:iCursor-blinkwait100-blinkon150-blinkoff150"
-- Highlight current line
vim.opt.cursorline = true

-- Enable better colors (I think 24-bit)
vim.opt.termguicolors = true

-- Tabs/Einrückungen auf 4 Leerzeichen setzen (Standard: 8 Zeichen lang, evtl. wird Tabulator-Zeichen verwendet und keine Leerzeichen)
-- <tabstop> in Kombination mit <shiftwidth> und <expandtab=true> sorgt dafür, dass immer 4 Leerzeichen für eine/n Tab/Einrückung gesetzt werden.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0   -- uses tabstop when 0
vim.opt.expandtab = true -- Deaktivieren per <set noexpandtab>
vim.opt.softtabstop = 4

-- Disable swap- and backup file
vim.opt.swapfile = true
-- set nobackup

-- Immer N Zeilen nach oben und nach unten haben, wenn man vertikal navigiert.
--   ==> So erreicht man nie den untersten Fenster-/Bildrand und es ist einfach
--   übersichtlicher
-- Gibt's auch für die Horizontale, s. <:help scrolloff>
vim.opt.scrolloff = 8

-- Rand für Zeilenlänge
--set colorcolumn=<N>

-- split vertically to the right when using :vsp, :vsplit, <C-v> in telescope
vim.opt.splitright = true
-- Horizontale Teilungen <:sp> werden unten (nicht darüber) angezeigt
-- split horizontally below when using :sp, :split
vim.opt.splitbelow = true

-- "=:;" handy for C-style languages
vim.bo.matchpairs = vim.bo.matchpairs .. ",„:“,=:;"
