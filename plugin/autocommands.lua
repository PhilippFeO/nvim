local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup


-- Disable signcolumn in my wiki (I won't commit it and need no git-signs information)
autocmd('BufWinEnter', {
    group = augroup('Disable-Signcolumn', { clear = true }),
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
    group = augroup('Document-Highlight-Normal', { clear = true }),
    callback = function()
        vim.lsp.buf.document_highlight()
    end,
    desc = 'Identifier highlighting on CursorHold'
})
-- I = Insert Mode
autocmd('CursorHoldI', {
    group = augroup('Document-Highlight-Insert', { clear = true }),
    callback = function()
        vim.lsp.buf.document_highlight()
    end,
    desc = 'Identifier highlighting in Insert Mode on CursorHold'
})
autocmd('CursorMoved', {
    group = augroup('Document-Highlight-Clear', { clear = true }),
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

-- Keymap to search files ignored by .gitignore.
-- I ignore regular wiki pages I don't want to upload to GitHub but sometimes
-- I want to read or edit them (obviously) and Telescope, ie. ripgrep is '.gitignore'
-- aware.
-- `no_ignore` also set in kitty-config to open Wiki.
autocmd('User', {
    group = augroup('Wiki-Group', { clear = true }),
    pattern = 'WikiBufferInitialized',
    callback = function()
        vim.keymap.set('n', '<Leader>f', function()
            local builtin = require('telescope.builtin')
            builtin.find_files({ no_ignore = true })
        end, { desc = "Finde Dateien mit 'no_ignore=true'" })
    end,
    desc = 'Modify Telescope.find_files to search ignored files.'
})
