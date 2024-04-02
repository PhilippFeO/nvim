-- Do not parse the file, if `h modifiable` is set.
-- Some keymaps might interefer with other g… mappings in modifiable buffers.
-- This is a little protection, because I only want these in non-modifiable buffers.
if vim.o.modifiable then
    return
end

-- Open vertical diff in new tab
-- Couldn't get it working using Lua-Syntax
--      vim.keymap.set('n', 'dt', '<Cmd>Gtabedit <Plug><cfile><Bar>Gvdiffsplit<CR>',
--          { buffer = true, desc = 'Open vertical diff in new tab' })
--      Opened a tab with split view but both were empty
vim.cmd([[nmap <buffer> dt :Gtabedit <Plug><cfile><Bar>Gvdiffsplit<CR>]])
-- tpope (plugin author) proposes following Autocommand: https://github.com/tpope/vim-fugitive/issues/1451#issuecomment-770310789
-- I dont know why using autocmd on FugitiveIndex and not placing the keymap in ftplugin/fugitive.lua
-- Below is the lua equivalent:
-- autocmd('User', {
--     group = augroup('My_Fugitive_Autocmds', { clear = true }),
--     pattern = 'FugitiveIndex',
--     -- callback = function()
--     --     vim.keymap.set('n', 'dt', '<Cmd>Gtabedit <Plug><cfile><Bar>Gvdiffsplit<CR>',
--     --         { noremap = false, buffer = true, desc = 'Open vertical diff in new tab' })
--     -- end,
--     -- Above Lua-Syntax doesn't work, I don't know why
--     command = 'nmap <buffer> dt :Gtabedit <Plug><cfile><Bar>Gvdiffsplit<CR>',
--     desc = 'Keymap for vertical diff in new tab'
-- })

local git_keymap = function(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

-- ─── git push ──────────
git_keymap('gp', '<Cmd>Git push<CR>', '[g]it [p]ush')
git_keymap('cgp', ':Git push -u origin ', 'Populate Command line with ":Git push -u origin"')

-- ─── git commit ──────────
git_keymap('cgc', ':Git commit ', 'Populate Commandline with "Git commit"')

-- ─── git log ──────────
git_keymap('gll', '<Cmd>Git log --graph -15<CR>', '[g]it [l]og --graph -15')
git_keymap('gla', '<Cmd>Git log --graph --all -15<CR>', '[g]it [l]og --graph --[a]ll -15')

-- TODO: Only in `fugitive` buffers set and available (`buffer = true`) but not needed there <25-01-2024>
git_keymap('gh', '<Cmd>diffget //2<CR>', 'Take theirs (left side in 3-way-merge-pane)')
git_keymap('gl', '<Cmd>diffget //3<CR>', 'Take ours (right side in 3-way-merge-pane)')
