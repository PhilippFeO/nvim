vim.keymap.set('n', '<BS>', '<Cmd>bdelete<CR>', { desc = 'Delete Buffer' })
-- cnoremap <silent><expr> <enter> index(['/', '?'], getcmdtype()) >= 0 ? '<enter>zz' : '<enter>'
vim.keymap.set('c', '<Enter>', function()
    local cmdtype = vim.fn.getcmdtype()
    if cmdtype == '/' or cmdtype == '?' then
        return '<Enter>zz'
    else
        return '<Enter>'
    end
end, {
    silent = true,
    expr = true,
    desc = 'Center after searching with / or ?',
})


-- ┌───────────────────┐
-- │ <Leader> Mappings │
-- └───────────────────┘
-- <Leader>, <LocalLeader> is set in init.lua, because lazy.nvim wishes so
--
-- Dieses Kopieren und Einfügen ohne dass das Markierte gespeichert wird und den alten Text überschreibt. Klappt irgendwie mit <Leader> nicht.
-- Im Visual-Mode markiertes wird durch vorher Geyanktes ersetzt ohne dass markierter Teil "das neue zu ersetzende" ist
vim.keymap.set('x', '<Leader>p', [["_dP]], { desc = 'Delete into \"_ and paste' })
-- Switch windows easier using basic vim movements
vim.keymap.set('n', '<Leader>h', '<C-w>h', { remap = true, desc = 'Go to window on the left' })
vim.keymap.set('n', '<Leader>j', '<C-w>j', { remap = true, desc = 'Go to window below' })
vim.keymap.set('n', '<Leader>k', '<C-w>k', { remap = true, desc = 'Go to window above' })
vim.keymap.set('n', '<Leader>l', '<C-w>l', { remap = true, desc = 'Go to window on the right' })

-- ─── make ──────────
-- Compile/Execute file and open Quickfix-List
-- :make executes string behind makeprg
-- s. RUNTIMEPATH/compiler/python.lua for example
-- maybe vim.fn.expand('%') is useful for having absolute paths
vim.keymap.set('n', '<Leader>mm', '<Cmd>w | make | cwindow 12<CR>',
    { desc = 'make/compile/execute current file' })
-- Without "<Cmd>" letters are typed
vim.keymap.set('n', '<Leader>ma', ':make %< ',
    { desc = '[m]ake with CLI [a]rguments' })
-- %< == Filename without extension, s. Wiki > neovim.md
vim.keymap.set('n', '<Leader>mr', '<Cmd>w | make run<CR>',
    { desc = '[m]ake and [r]un current file' })
-- TODO: Transform to Autocommand triggering for grocery_shopper dir <17-04-2024>
vim.keymap.set('n', '<Leader>mp', '<Cmd>make pdf<CR>',
    { desc = '[m]ake [p]df' })
-- Run Tests
vim.keymap.set('n', '<Leader>mt', '<Cmd>w | make test<CR>',
    { desc = '[m]ake and run [t]ests' })
-- Same as above but suppressing output of `make` via `:silent`
vim.keymap.set('n', '<Leader>ms', '<Cmd>w | silent make | cwindow 12<CR>',
    { silent = true, desc = '[m]ake/compile/execute [s]ilently current file' })

-- Generate substitution command for current word
-- vim.keymap.set('n', '<Leader>c', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
--     { desc = '[s]ubstitute current word' })

-- Copy into System Clipboard
vim.keymap.set('v', '<Leader>y', [["+y]], { desc = 'Copy into system clipboard' })
vim.keymap.set('n', '<Leader>y', [["+y]], { desc = 'Copy line into system clipboard' })
vim.keymap.set('n', '<Leader>Y', [["+Y]], { desc = 'Copy rest of line into system clipboard' })
vim.keymap.set('n', '<Leader>x', '<Cmd>!chmod +x %<CR>', { desc = 'Make script executable' })

local bracketPairs = {
    ['('] = ')',
    [')'] = '(',
    ['['] = ']',
    [']'] = '[',
    ['{'] = '}',
    ['}'] = '{',
    ['<'] = '>',
    ['>'] = '<',
}
vim.keymap.set('n', '<LocalLeader>r', function()
    local bracket = vim.fn.nr2char(vim.fn.getchar())
    local counterpart = bracketPairs[bracket]
    vim.cmd.execute('"normal mb%r' .. counterpart .. '`br' .. bracket .. '"')
end, { desc = "Replace bracket pairs" })
vim.keymap.set('n', '<LocalLeader>w', '<Cmd>w<CR>', { silent = true, desc = 'Save in Normal Mode' })

-- ┌────────────────┐
-- │ <C-…> Mappings │
-- └────────────────┘
-- Mapping involving CTRL, ie. <C-…>
--
-- Scroll half page down and center
-- zz centers current line (no need to 'search' the screen as without `h zt`)
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll [d]own and center' })
-- like above but upwards
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll [u]p and center' })
-- `h jumplist` navigation
vim.keymap.set('n', '<C-o>', '<C-o>zz', { desc = 'Center after moving down in jumplist' })

-- TODO: Breaks wiki.vim, iw. <Tab> doesn't trigger :WikiLinkNext <04-01-2024>
--      ? <C-i> triggers :WikiLinkNext
--      > In Issues nachsehen, ich habe dort mal gefragt
-- vim.keymap.set('n', '<C-i>', '<C-i>zz', { desc = 'Center after moving up in jumplist' })

-- `h taglist` navigation
vim.keymap.set('n', '<C-t>', '<C-t>zz', { desc = 'Center after moving down in taglist' })


-- ┌───────────────────┐
-- │ "Letter" Mappings │
-- └───────────────────┘
-- All mappings here use merely letters, ie. no <Leader>, <C-…>, <A-…>, etc.
--
-- Keymaps for better default experience
-- See `h vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'G', 'Gzt') -- Elevate view after going to last line
-- Remap for dealing with line wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<C-j>', 'gj', { remap = true })
vim.keymap.set('n', '<C-k>', 'gk', { remap = true })
-- Mit <J> kann man im Normal-Mode die untere Zeile an die aktuelle hängen,
-- allerdings wird dabei der Cursor an die Schnittstelle gesetzt. Das folgende
-- Mapping sorgt dafür, dass der Cursor an aktueller Stelle verbleibt
-- Quelle: https://www.youtube.com/watch?v=w7i4amO_zaE&t=1464s
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines (slightly modified, s. keymaps.lua)' })
-- Beim suchen kann man mit n (vorwärts) und N (rückwärts) zu den nächsten
-- Treffern navigieren und wird auf nzz abgebildet
-- zz zentriert Cursor/Treffer in der Mitte, man muss beim Navigieren nicht
-- suchen und kann immer auf eine Stelle schauen
-- zv klappt zusammengeklappte Blöcke aus (verwende ich noch nicht, 9.1.23, { noremap = true })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next hit of search' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous hit of search' })
-- faster quitting
vim.keymap.set('n', 'QQ', '<Cmd>q!<CR>', { desc = 'Force [QQ]uit (:q!)' })
vim.keymap.set('n', 'QA', '<Cmd>qa!<CR>', { desc = 'Force [Q]uit [A]ll (:qa!)' })
-- Press 'öl' to return to normal mode when in insert or visual mode
vim.keymap.set({ 'i', 'v' }, '<LocalLeader>l', '<ESC>', { desc = 'Enter Normal Mode' })
-- Move visually selected lines
-- Source: https://www.youtube.com/watch?v=w7i4amO_zaE&t=1464s
vim.keymap.set('v', 'J', ":m'>+1<CR>gv=gv", { desc = 'Move visually selected lines down' })
vim.keymap.set('v', 'K', ":m'<-2<CR>gv=gv", { desc = 'Move visually selected lines up' })
vim.keymap.set('c', '%%', function()
    if vim.fn.getcmdtype() == ':' then
        return vim.fn.expand('%:h') .. '/'
    else
        return '%%'
    end
end, { expr = true, desc = 'Insert directory of buffer' })

-- ┌─────────────┐
-- │ []-Mappings │
-- └─────────────┘
-- All mappings here start with [ or ]
--
-- When jumping to a function, I want to see as much as possible from it's body, hence zt and not zz
vim.keymap.set('n', '[m', '[mzt', { desc = 'Jump to previous @function.outer' })
vim.keymap.set('n', ']m', ']mzt', { desc = 'Jump to next @function.outer' })
-- Add empty lines
vim.keymap.set('n', ']<Space>', '<Cmd>normal o<CR>', { desc = 'Add one empty line below cursor' })
vim.keymap.set('n', '[<Space>', '<Cmd>normal O<CR>', { desc = 'Add one empty line above cursor' })
vim.keymap.set('n', '[[', '[[zz', { desc = 'Center view after going to previous section' })
vim.keymap.set('n', ']]', ']]zz', { desc = 'Center view after going to next section' })
vim.keymap.set('n', '[q', '<Cmd>cprevious | copen | norm zt<C-e><C-w>pzz<CR>', { desc = "Previous Quickfix-List entry" })
-- Öffne QuickFix-Liste oder springe zu ihr
-- Schiebe Einträge nach oben
-- Scrolle eine Zeile hoch (Jetzt sollte aktiver QF-Eintrag ganz oben stehen)
-- Springe zurück ins lezte aktive Fenster (manchmal hat man 2 offen)
vim.keymap.set('n', ']q', '<Cmd>cnext | copen | norm zt<C-e><C-w>pzz<CR>', { desc = "Next Quickfix-List entry" })

vim.keymap.set('n', '[b', '<Cmd>bprevious<CR>', { desc = "Previous Buffer" })
vim.keymap.set('n', ']b', '<Cmd>bnext<CR>', { desc = "Next Buffer" })

vim.keymap.set('n', '{', '{zz', { desc = 'Center after {' })
vim.keymap.set('n', '}', '}zz', { desc = 'Center after }' })

-- ┌──────────────┐
-- │ Alt-Mappings │
-- └──────────────┘
-- All mappings follow <A-…>
vim.keymap.set('i', '<A-x>', '<C-o>', { desc = '<C-o> but easier to type' })
