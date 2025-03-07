-- Loads RUNTIMEPATH/compiler/python.lua
vim.cmd.compiler('python')

local group_id = vim.api.nvim_create_augroup("MakePDF", { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
    group = group_id,
    pattern = '*/grocery_shopper/*',
    callback = function()
        vim.keymap.set('n', '<Leader>mp', '<Cmd>make pdf<CR>', { desc = '[m]ake [p]df' })
    end
})

-- Highlights
-- ──────────
local kanagawa_palette = require("kanagawa.colors").setup().palette
-- Manly used when working with *.ju.py files
local highlight = vim.api.nvim_set_hl
highlight(0, 'JupyniumMarkdownCellSeparator', { fg = kanagawa_palette.oniViolet2 })
-- Clear highlight of Markdown cells (distracting)
highlight(0, 'JupyniumMarkdownCellContent', {})
highlight(0, 'JupyniumCodeCellSeparator', { italic = false, fg = kanagawa_palette.autumnGreen })


-- ─── User Commands ──────────
-- Save and execute python program
vim.api.nvim_create_user_command('P', 'w | !python3 %', {})


-- ─── Autocommands ──────────
-- The following autocommand(s) serve as workflow utilities when solving leetcode challenges.
-- On save the programs is executed and its output displayed on a fresh buffer.

-- Erinnerung: <leader> <leader> x um Datei zu speichern und auszuführen

local bufnr = -1
group_id = vim.api.nvim_create_augroup("SaveAndExecute", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
    group = group_id,
    -- pattern = { '*/leetcode/*', '*/python/*' }, -- Apply only to files below dir "leetcode"
    pattern = '*/leetcode/*', -- Apply only to files below dir "leetcode"
    callback = function()
        -- open new buffer, to this buffer will be written
        if bufnr == -1 then
            vim.cmd.vsplit()
            vim.cmd.enew() -- New buffer
            -- vim.o.readonly = true
            bufnr = vim.api.nvim_get_current_buf()
        end
        -- Better have one initial line to clear Buffer contents.
        -- Doesn't work with on_stdout/err (s. below)
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "=== Output ===" }) -- wenn das verwendet wird, muss weiter unten -1 für STARTZEILE verwendet werden, um anzuhängen
        vim.fn.jobstart({ "python3", vim.fn.expand('%') },
            -- 2. Arg.: Was mit der Ausgabe passieren soll
            {
                stdout_buffered = true, -- Passes output of <jobstart> rowwise
                stderr_buffered = true,
                -- If not appended at the end (f.i. 0, -1 for on_stdout/err) stderr overwrites stdout in the
                -- buffer
                on_stdout = function(_, data)
                    if data then
                        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
                    end
                end,
                on_stderr = function(_, data)
                    if data then
                        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
                    end
                end
            })
    end
})
