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

-- ─── git push ──────────
-- Git push origin HEAD
vim.keymap.set('n', 'gp', '<Cmd>Git push origin HEAD<CR>', { buffer = true, desc = '[g]it [p]ush origin HEAD' })

-- ─── git commit ──────────
-- git commit --amend --no-edit
vim.keymap.set('n', 'gca', '<Cmd>Git commit --amend --no-edit<CR>',
    { buffer = true, desc = '[g]it [c]ommit --[a]mend --no-edit' })

-- ─── git log ──────────
-- git log --graph
vim.keymap.set('n', 'gll', '<Cmd>Git log --graph<CR>', { buffer = true, desc = '[g]it [l]og --graph' })
-- git log --graph --all -15
vim.keymap.set('n', 'gla', '<Cmd>Git log --graph --all -15<CR>',
    { buffer = true, desc = '[g]it [l]og --graph --[a]ll -15' })
