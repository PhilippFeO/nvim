-- [[ Basic Keymaps ]]

-- ┌───────────────────┐
-- │ <Leader> Mappings │
-- └───────────────────┘
-- <Leader>, <LocalLeader> is set in init.lua, because lazy.nvim wishes so

-- Dieses Kopieren und Einfügen ohne dass das Markierte gespeichert wird und den alten Text überschreibt. Klappt irgendwie mit <Leader> nicht.
-- Im Visual-Mode markiertes wird durch vorher Geyanktes ersetzt ohne dass markierter Teil "das neue zu ersetzende" ist
vim.api.nvim_set_keymap('x', '<Leader>p', [["_dP]], { noremap = true, desc = 'Delete into \"_ and paste' })

-- Switch windows easier using basic vim movements
vim.keymap.set('n', '<Leader>h', '<C-w>h', { remap = true, desc = 'Go to window on the left' })
vim.keymap.set('n', '<Leader>j', '<C-w>j', { remap = true, desc = 'Go to window below' })
vim.keymap.set('n', '<Leader>k', '<C-w>k', { remap = true, desc = 'Go to window above' })
vim.keymap.set('n', '<Leader>l', '<C-w>l', { remap = true, desc = 'Go to window on the right' })
-- :make executes string behind makeprg
-- s. RUNTIMEPATH/compiler/python.lua for example
-- maybe vim.fn.expand('%') is useful for having absolute paths
vim.keymap.set('n', '<Leader>m', '<Cmd>make %<CR>', { desc = 'Compile/Execute current file' })


-- Beim Betätigen von <<Leader>s> wird automatisch ein Ersetzungsbefehl generiert, um das aktuelle Wort zu ersetzen. So muss man es nicht extr eintippen."
vim.api.nvim_set_keymap('n', '<Leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { noremap = true, desc = '[s]earch for current word' })
-- In die System-Zwischenablage kopieren
vim.api.nvim_set_keymap('v', '<Leader>y', [["+y]], { noremap = true, desc = 'Copy into system clipboard' })
vim.api.nvim_set_keymap('n', '<Leader>y', [["+y]], { noremap = true, desc = 'Copy line into system clipboard' })
vim.api.nvim_set_keymap('n', '<Leader>Y', [["+Y]], { noremap = true, desc = 'Copy rest of line into system clipboard' })

-- Macht Skripte automatisch ausführbar
vim.api.nvim_set_keymap('n', '<Leader>x', '<cmd>!chmod +x %<CR>', { noremap = true, desc = 'Make script executable' })

-- save and source current file (following <Localleader>ll for compiling LaTeX via vimtex)
vim.keymap.set('n', '<Localleader>xx', '<Cmd>w | source %<CR>', { noremap = true, desc = 'Save and source current file' })


-- ┌────────────────┐
-- │ <C-?> Mappings │
-- └────────────────┘
-- Ab hier finden sich alle Mappings, die die STRG-Taste (<C-?>) bedienen

-- <C-d> = STRG + d bewegt halbe Seite NACH UNTEN und wird auf <C-d>zz
-- abgebildet
-- zz zentriert Cursor in der Mitte
--  ==> So muss man beim navigieren immer nur auf eine Stelle schauen und nicht
--  den Cursor suchen
vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', { noremap = true })
-- wie oben nur halbe Seite NACH OBEN
vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', { noremap = true })
vim.keymap.set('n', '<C-o>', '<C-o>zz', { desc = 'Center after moving down in jumplist' })
vim.keymap.set('n', '<C-t>', '<C-t>zz', { desc = 'Center after moving down in taglist' })
vim.keymap.set('n', '[m', '[mzz', { desc = 'Center after jumping to previous @function.outer' })
vim.keymap.set('n', ']m', ']mzz', { desc = 'Center after jumping to next @function.outer' })

-- Adjust split size via <ALT-[hjkl]>
-- vim.api.nvim_set_keymap('n', '<A-h>', '<Cmd>vertical resize -5<CR>', { noremap = true, desc = 'Shrink vertical split' })
-- vim.api.nvim_set_keymap('n', '<A-l>', '<Cmd>vertical resize +5<CR>', { noremap = true, desc = 'Enlarge vertical split' })
-- vim.api.nvim_set_keymap('n', '<A-j>', '<Cmd>resize -5<CR>', { noremap = true, desc = 'Shrink horizontal split' })
-- vim.api.nvim_set_keymap('n', '<A-k>', '<Cmd>resize +5<CR>', { noremap = true, desc = 'Enlarge horizontal split' })


-- ┌───────────────────┐
-- │ "Letter" Mappings │
-- └───────────────────┘
-- Alle hier gelisteten Tastenkombinationen benutzen lediglich Buchstaben

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Center view after going to last line
vim.keymap.set('n', 'G', 'Gzz')
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Mit <J> kann man im Normal-Mode die untere Zeile an die aktuelle hängen,
-- allerdings wird dabei der Cursor an die Schnittstelle gesetzt. Das folgende
-- Mapping sorgt dafür, dass der Cursor an aktueller Stelle verbleibt
-- Quelle: https://www.youtube.com/watch?v=w7i4amO_zaE&t=1464s
vim.api.nvim_set_keymap('n', 'J', 'mzJ`z', { noremap = true })

-- Beim suchen kann man mit n (vorwärts) und N (rückwärts) zu den nächsten
-- Treffern navigieren und wird auf nzz abgebildet
-- zz zentriert Cursor/Treffer in der Mitte, man muss beim Navigieren nicht
-- suchen und kann immer auf eine Stelle schauen
-- zv klappt zusammengeklappte Blöcke aus (verwende ich noch nicht, 9.1.23, { noremap = true })
vim.api.nvim_set_keymap('n', 'n', 'nzzzv', { noremap = true })
vim.api.nvim_set_keymap('n', 'N', 'Nzzzv', { noremap = true })

-- faster quitting
vim.keymap.set('n', 'QQ', '<Cmd>q!<CR>', { desc = 'Force [QQ]uit (:q!)' })
vim.keymap.set('n', 'QA', '<Cmd>qa!<CR>', { desc = 'Force [Q]uit [A]ll (:qa!)' })

-- Go to previous buffer (especially when using a wiki)
vim.keymap.set('n', '<BS>', '<Cmd>bprev<CR>')
vim.keymap.set('n', '<C-BS>', '<Cmd>bnext<CR>')

-- Press ij to return to normal mode when in insert or visual mode
-- inoremap <ESC> <NOP> " Deaktiviert ESC-Taste
vim.keymap.set({ 'i', 'v' }, 'öl', '<ESC>', { noremap = true })
-- Press ij to return to normal mode when in visual mode
-- vnoremap <ESC> <NOP> " Deaktiviert ESC-Taste
-- vim.api.nvim_set_keymap("v", "ij", "<ESC>", { noremap = true })

-- Im Visual-Mode markierte Zeilen können per <J> und <K> verschoben werden
-- Quelle: https://www.youtube.com/watch?v=w7i4amO_zaE&t=1464s
vim.api.nvim_set_keymap('v', 'J', ":m'>+1<CR>gv=gv", { noremap = true })
vim.api.nvim_set_keymap('v', 'K', ":m'<-2<CR>gv=gv", { noremap = true })

-- ┌──────┐
-- │ Misc │
-- └──────┘
-- vim.keymap.set('n', '[[', '[[zz', { remap = true, desc = 'Center view after going to previous section (in LaTeX)' })
-- vim.api.nvim_set_keymap('n', '[[', '[[zz',
-- { noremap = true, desc = 'Center view after going to previous section (in LaTeX)' })
-- vim.keymap.set('n', ']]', ']]zz', { remap = true, desc = 'Center view after going to next section (in LaTeX)' })

-- ", and ' completion
-- vim.api.nvim_set_keymap("i", "\"", "\"\"<Left>", { noremap = true })
-- vim.api.nvim_set_keymap("i", "'", "''<Left>", { noremap = true })

-- Überschreibt schließende Klammer/Anführungszeichen
-- Praktisch, va. wenn man in Python Funktionen definiert, da man sonst
-- umständlich per ESC A hinter die Klammer wechseln müsste, so tippt man sie
-- einfach schnell.
-- vim.api.nvim_set_keymap("i", "<expr> )", [[strpart(getline('.'), col('.')-1, 1) == ) ? <Right> : )]], { noremap = true })
-- vim.api.nvim_set_keymap("i", "<expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" :", ""}"", { noremap = true })
-- vim.api.nvim_set_keymap("i", "<expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" :", ""]"", { noremap = true })
--vim.api.nvim_set_keymap("i", "<expr> '", strpart(getline('.'), col('.')-1, 1) == "'" ? "\<Right>" :", ""''<Left>"", { noremap = true })
-- vim.cmd([[ inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == "\"" ? "\<Right>" : "\"\"<Left>" ]])
-- vim.cmd([[ inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "'" ? "\<Right>" : "''<Left>" ]])
