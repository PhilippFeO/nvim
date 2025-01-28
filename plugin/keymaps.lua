local dap = require 'dap'
local dapui = require 'dapui'


vim.keymap.set('n', '<Leader>n', function()
    local x = vim.fn.getreg("a")
    print(x)
end, { desc = 'Get contents of register a' })


vim.keymap.set('n', '<BS>', vim.cmd.close, { desc = 'Close window' })
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
vim.keymap.set('n', '<Leader>et', function()
    local f = io.open('todo.md', 'r')
    if f ~= nil then
        io.close(f)
        vim.cmd.tabedit('todo.md')
    else
        print("File 'todo.md' doesn't exists")
    end
end, { desc = 'Edit todo.md' })
-- Dieses Kopieren und Einfügen ohne dass das Markierte gespeichert wird und den alten Text überschreibt. Klappt irgendwie mit <Leader> nicht.
-- Im Visual-Mode markiertes wird durch vorher Geyanktes ersetzt ohne dass markierter Teil "das neue zu ersetzende" ist
vim.keymap.set('x', '<Leader>p', [["_dP]], { desc = 'Delete into \"_ and paste' })
-- Switch windows easier using basic vim movements
vim.keymap.set('n', '<Leader>h', '<C-w>h', { remap = true, desc = 'Go to window on the left' })
vim.keymap.set('n', '<Leader>j', '<C-w>j', { remap = true, desc = 'Go to window below' })
vim.keymap.set('n', '<Leader>k', '<C-w>k', { remap = true, desc = 'Go to window above' })
vim.keymap.set('n', '<Leader>l', '<C-w>l', { remap = true, desc = 'Go to window on the right' })
vim.keymap.set('n', '<Leader><Leader>x', '<Cmd>write | source %<CR>', { desc = 'Execute (source) current file' })
vim.keymap.set('n', '<Leader>x', '.lua<CR>', { desc = 'E[x]ecute current line' })
vim.keymap.set('v', '<Leader>x', ':lua<CR>', { desc = 'E[x]ecute selected lines' })
vim.keymap.set('n', '<LocalLeader>c', function() require 'treesitter-context'.toggle() end,
    { desc = 'toggle treesitter-[c]ontext' }
)
vim.keymap.set({ 'n' }, '<Leader>,', 'vt,', { desc = 'visual select until [,]' })

-- ─── make ──────────
-- Compile/Execute file and open Quickfix-List
-- :make executes string behind makeprg
-- s. RUNTIMEPATH/compiler/python.lua for example
-- maybe vim.fn.expand('%') is useful for having absolute paths
vim.keymap.set('n', '<Leader>mm', '<Cmd>w | make | cwindow 12 | wincmd k<CR>',
    { desc = 'make/compile/execute current file' })
-- Without "<Cmd>" letters are typed
vim.keymap.set('n', '<Leader>ma', ':make %< ',
    { desc = '[m]ake with CLI [a]rguments' })
-- %< == Filename without extension, s. Wiki > neovim.md
vim.keymap.set('n', '<Leader>mr', '<Cmd>w | make run<CR>',
    { desc = '[m]ake and [r]un current file' })
-- Run Tests
vim.keymap.set('n', '<Leader>mt', '<Cmd>w | make test<CR>',
    { desc = '[m]ake and run [t]ests' })
-- Same as above but suppressing output of `make` via `:silent`
vim.keymap.set('n', '<Leader>ms', '<Cmd>w | silent make | cwindow 12 | wincmd k<CR>',
    { silent = true, desc = '[m]ake/compile/execute [s]ilently current file' })

-- Generate substitution command for current word
-- vim.keymap.set('n', '<Leader>c', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
--     { desc = '[s]ubstitute current word' })

-- Copy into System Clipboard
vim.keymap.set({ 'v', 'n' }, '<Leader>y', [["+y]], { desc = 'Copy into system clipboard' })
vim.keymap.set('n', '<Leader>Y', [["+v$y]], { desc = 'Copy rest of line into system clipboard' })

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
vim.keymap.set('n', 'gd', 'gdzz', { remap = true, desc = '[g]oto [d]efinition and center (ugdzz)' })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n' }, 'CC', function()
        vim.cmd.cclose()
        -- Reset DAP-UI if debug session is running
        if dap.session() then
            dapui.open({ reset = true })
        end
        -- Jump back to previous window, `CTRL-W_p == :wincmd p == vim.cmd.wincmd('p')`
        -- `h :wincmd`, `h CTRL-W_p`
        vim.cmd.wincmd('p')
    end,
    { desc = 'Close Quickfix-List window' }
)
vim.keymap.set('n', 'G', 'Gzz') -- Elevate view after going to last line
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
-- Usually, :substitute works on lines only, \%V makes it work on visual selection
vim.keymap.set('v', ':vs', ":s/\\%V\\%V/<Left><Left><Left><Left>", { desc = ':s for visual selection' })
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
vim.keymap.set('n', '<A-j>', '<Cmd>cnext | copen | norm zt<C-e><C-w>pzz<CR>',
    { desc = "Previous Quickfix-List entry" })
-- Öffne QuickFix-Liste oder springe zu ihr
-- Schiebe Einträge nach oben
-- Scrolle eine Zeile hoch (Jetzt sollte aktiver QF-Eintrag ganz oben stehen)
-- Springe zurück ins lezte aktive Fenster (manchmal hat man 2 offen)
vim.keymap.set('n', '<A-k>', '<Cmd>cprevious | copen | norm zt<C-e><C-w>pzz<CR>', { desc = "Next Quickfix-List entry" })

vim.keymap.set('n', '[b', '<Cmd>bprevious<CR>', { desc = "Previous Buffer" })
vim.keymap.set('n', ']b', '<Cmd>bnext<CR>', { desc = "Next Buffer" })

vim.keymap.set('n', '{', '{zz', { desc = 'Center after {' })
vim.keymap.set('n', '}', '}zz', { desc = 'Center after }' })

-- ┌──────────────┐
-- │ Alt-Mappings │
-- └──────────────┘
-- All mappings follow <A-…>
vim.keymap.set('i', '<A-x>', '<C-o>', { desc = '<C-o> but easier to type' })
-- Flip boolean
vim.keymap.set('n', '<A-f>', function()
        -- Save position to reset cursor after replacement
        local pos = vim.api.nvim_win_get_cursor(0)
        -- Set cursor at the start of the line
        -- (otherwise matches before the cursor are ignored)
        vim.api.nvim_win_set_cursor(0, { vim.fn.line('.'), 0 })

        local bool_val_map = {
            'true',
            'false',
            'True',
            'False',
        }
        local bool_val_inverted_map = {
            'false',
            'true',
            'False',
            'True',
        }
        for i = 1, #bool_val_map do
            -- Search for boolean value in current line
            -- `:h /ignorecase`
            local pattern = string.format('\\C%s', bool_val_map[i])
            local search_result = vim.fn.search(pattern, '', vim.fn.line('.'))
            -- Check if the search was successful
            if search_result > 0 then
                -- Flip boolean value
                vim.cmd(string.format('s/%s/%s/', bool_val_map[i], bool_val_inverted_map[i]))
                break
            end
        end

        -- Set cursor to the position bevore replacement
        vim.api.nvim_win_set_cursor(0, pos)
    end,
    {
        desc = '[f]lip bool',
    }
)
