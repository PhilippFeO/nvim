local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local dap = require('dap')

-- Disable signcolumn in my wiki (I won't commit it and need no git-signs information)
autocmd('BufWinEnter', {
    group = augroup('Disable-Signcolumn', { clear = true }),
    pattern = vim.fn.expand('~') .. '/wiki/*',
    callback = function()
        vim.wo.signcolumn = 'no'
    end,
    desc = 'Disable signcolumn in Wiki'
})

-- autocmd('BufWinEnter', {
--     group = augroup('Disable-Ruff', { clear = true }),
--     pattern = vim.fn.expand('~') .. '/python/atp-osse/*',
--     command = 'LspStop ruff',
--     desc = 'Disable ruff for atp-osse',
-- })


-- WinEnter, WinNew
autocmd('FileReadPost', {
    group = augroup('CloseFolds', { clear = true }),
    pattern = '*.py',
    callback = function()
        require('ufo').closeAllFolds()
    end,
    desc = 'Close all Folds using nvim-ufo'
})

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

autocmd('BufReadPost', {
    group = augroup('HTMLdjango', { clear = true }),
    pattern = '*/kursverwaltung/*.html',
    command = 'set ft=htmldjango',
    desc = 'Set ft to "htmldjango" within kursverwaltung/'
})
-- ─── LSP Autocommands ──────────
-- TODO: Edit kanagawa.nvim or highlight groups using kanagawa's palette because highlight group colors are ugly
-- TODO: Which highlight group is used by vim.lsp.buf.document_highlight()?
-- autocmd('CursorHold', {
--     group = augroup('Document-Highlight-Normal', { clear = true }),
--     callback = function()
--         vim.lsp.buf.document_highlight()
--     end,
--     desc = 'Identifier highlighting on CursorHold'
-- })
-- -- I = Insert Mode
-- autocmd('CursorHoldI', {
--     group = augroup('Document-Highlight-Insert', { clear = true }),
--     callback = function()
--         vim.lsp.buf.document_highlight()
--     end,
--     desc = 'Identifier highlighting in Insert Mode on CursorHold'
-- })
-- autocmd('CursorMoved', {
--     group = augroup('Document-Highlight-Clear', { clear = true }),
--     callback = function()
--         vim.lsp.buf.clear_references()
--     end,
--     desc = 'Remove identifier highlighting on CorsorMoved'
-- })
--

-- CODEIUM
-- ───────
-- Deaktiviere Codeium beim Start
--autocmd('VimEnter', {
--    command = 'Codeium Disable',
--    desc = 'Disable Codeium on startup.'
--})


autocmd('TermOpen', {
    group = augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
    end
})


autocmd('BufWritePost', {
    group = augroup('reload-python-dap-configs', { clear = true }),
    pattern = '*.py',
    callback = function()
        --[[ The different dap configs are distributed over different files (s. dap-configs/python.lua) and required in the aforementioned file.
        Since required calls are cached just reloading dap-configs/python.lua has no effect, because the already loaded values are fetched. To circument this, the cached values are deleted by setting the key to nil. Then, they are rerequired in `require 'dap-configs.python`.
        -- ]]
        for key, _ in pairs(package.loaded) do
            if key:match('^dap%-configs%.python') then
                package.loaded[key] = nil
            end
        end
        require 'dap-configs.python'
    end,
    desc = 'Reload Python DAP Configs',
})
