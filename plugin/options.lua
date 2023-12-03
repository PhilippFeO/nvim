-- [[ Setting options ]]
-- See `:help vim.o`

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
vim.o.smartcase = true

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

-- Deaktivieren der Maus (scrollen funktioniert aber noch)
vim.opt.mouse = ""

-- Deprecated due to use of lualine
-- statusline
-- Dateiname und prozentuale vertikale Position.
--vim.opt.statusline = "%t    %p%% of %L Lines"

-- winbar
-- s. :h statusline for formatting
--  %=  shift to the right
--  %m  idicates modified or not
--  %f  path to file
vim.o.winbar = "%=%m %f"

-- Fenstertitel zeigt Dateiname
vim.opt.title = true

-- (Relative) Zeilennummerierung
vim.opt.number = true
vim.opt.relativenumber = true

-- Rechteckiger Cursor im Insert-Mode (Der Standard ist in Neovim ein Strich, "wie man ihn kennt")
vim.opt.guicursor = "i-ci:iCursor-blinkwait100-blinkon150-blinkoff150"
-- Aktuelle Zeile hervorheben
vim.opt.cursorline = true

-- Ignoriere Groß- und Kleinschreibung bei der Suche
vim.opt.ignorecase = true

-- Aktiviert 24-Bit-Farben (davor 8-Bit)
-- (Man sollte nun mehr/bessere/kontrastreichere Farben zur Verfügung haben)
vim.opt.termguicolors = true

-- Tabs/Einrückungen auf 4 Leerzeichen setzen (Standard: 8 Zeichen lang, evtl. wird Tabulator-Zeichen verwendet und keine Leerzeichen)
-- <tabstop> in Kombination mit <shiftwidth> und <expandtab=true> sorgt dafür, dass immer 4 Leerzeichen für eine/n Tab/Einrückung gesetzt werden.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0   -- uses tabstop when 0
vim.opt.expandtab = true -- Deaktivieren per <set noexpandtab>
vim.opt.softtabstop = 4

-- Swap- und Backup-Datei deaktivieren
vim.opt.swapfile = false
--set nobackup

-- Immer N Zeilen nach oben und nach unten haben, wenn man vertikal navigiert.
--   ==> So erreicht man nie den untersten Fenster-/Bildrand und es ist einfach
--   übersichtlicher
-- Gibt's auch für die Horizontale, s. <:help scrolloff>
vim.opt.scrolloff = 8

-- Rand für Zeilenlänge
--set colorcolumn=<N>

-- Vertikale Teilungen per <:vs[p]> (:vsplit) werden rechts angezeigt, nicht links
vim.opt.splitright = true
-- Horizontale Teilungen <:sp> werden unten (nicht darüber) angezeigt
vim.opt.splitbelow = true
