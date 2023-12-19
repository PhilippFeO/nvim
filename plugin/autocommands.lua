local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup


-- FOLDS
-- ─────
-- Save and load folds
-- autocmd('BufWinLeave', {
--     pattern = '*.*',
--     command = 'mkview',
--     desc = 'Save folds.'
-- })

-- Shorter with VimScript:
--      au BufWinEnter *.* silent! loadview
-- autocmd('BufWinEnter', {
--     pattern = '*',
--     command = 'silent! loadview',
--     desc = "Load saved folds."
-- })

-- Disable signcolumn in my wiki (I won't commit it and need no git-signs information)
autocmd('BufWinEnter', {
    group = vim.api.nvim_create_augroup('Disable-Signcolumn', { clear = true }),
    pattern = '/home/philipp/wiki/*',
    callback = function()
        vim.wo.signcolumn = 'no'
    end,
    desc = 'Disable signcolumn in Wiki'
})

-- ─── LSP Autocommands ──────────
-- TODO: Edit kanagawa.nvim or highlight groups using kanagawa's palette because highlight group colors are ugly
-- TODO: Which highlight group is used by vim.lsp.buf.document_highlight()?
autocmd('CursorHold', {
    group = vim.api.nvim_create_augroup('Document-Highlight-Normal', { clear = true }),
    callback = function()
        vim.lsp.buf.document_highlight()
    end,
    desc = 'Identifier highlighting on CursorHold'
})
-- I = Insert Mode
autocmd('CursorHoldI', {
    group = vim.api.nvim_create_augroup('Document-Highlight-Insert', { clear = true }),
    callback = function()
        vim.lsp.buf.document_highlight()
    end,
    desc = 'Identifier highlighting in Insert Mode on CursorHold'
})
autocmd('CursorMoved', {
    group = vim.api.nvim_create_augroup('Document-Highlight-Clear', { clear = true }),
    callback = function()
        vim.lsp.buf.clear_references()
    end,
    desc = 'Remove identifier highlighting on CorsorMoved'
})


-- CODEIUM
-- ───────
-- Deaktiviere Codeium beim Start
--autocmd('VimEnter', {
--    command = 'Codeium Disable',
--    desc = 'Disable Codeium on startup.'
--})
