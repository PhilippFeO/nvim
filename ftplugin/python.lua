-- Loads RUNTIMEPATH/compiler/python.lua
vim.cmd.compiler('python')


local ts_utils = require 'nvim-treesitter.ts_utils'

-- local function format_function_calls()
--     local bufnr = vim.api.nvim_get_current_buf()
--     -- Get language tree
--     local language_tree = vim.treesitter.get_parser(bufnr, 'python')
--     -- Build syntax tree
--     local syntax_tree = language_tree:parse()
--     -- Get root node
--     local root = syntax_tree[1]:root()
--
--     local query = [[
--     (call
--       function: (identifier)  ; Match the function name
--       arguments: (argument_list
--         (argument
--           (expression)  ; Match each argument expression
--         )*
--       )
--     )
--   ]]
--
--     -- Collect all matches
--     local matches = {}
--     for _, node in ipairs(root:iter_children()) do
--         for match in vim.treesitter.query.parse('python', query):iter_matches(node, bufnr) do
--             table.insert(matches, match)
--         end
--     end
--
--     -- Format each matched function call
--     for _, match in ipairs(matches) do
--         local node = match[1] -- The first capture group is the function call
--         local start_row, start_col, end_row, end_col = node:range()
--         local line = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)[1]
--
--         -- Format the function call
--         local formatted_line = line:gsub("(%w+%s*%b())", function(call)
--             return call:gsub(",", ",\n  ") -- Add newline before each comma
--         end)
--
--         -- Replace the original line with the formatted line
--         vim.api.nvim_buf_set_lines(bufnr, start_row, end_row + 1, false, { formatted_line })
--     end
-- end
--
-- -- Map the function to a command or keybinding
-- vim.api.nvim_create_user_command('FormatFunctionCalls', format_function_calls, {})
--


-- ─── User Commands ──────────
-- Save and execute python program
vim.api.nvim_create_user_command('P', 'w | !python3 %', {})


-- ─── Autocommands ──────────
-- The following autocommand(s) serve as workflow utilities when solving leetcode challenges.
-- On save the programs is executed and its output displayed on a fresh buffer.

-- Erinnerung: <leader> <leader> x um Datei zu speichern und auszuführen

local bufnr = -1
local group_id = vim.api.nvim_create_augroup("SaveAndExecute", { clear = true })

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
