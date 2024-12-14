-- Loads RUNTIMEPATH/compiler/python.lua
vim.cmd.compiler('python')

local ts_utils = require 'nvim-treesitter.ts_utils'
local ts = vim.treesitter

local function format_function_call()
    local bufnr = 0
    -- Assume cursor sit's anywhere on the `call` subbranch
    -- 1. Find `call` node
    -- 2. Get the `argument_list` node
    -- Only when current node isn't already `argument_list`
    local node = ts_utils.get_node_at_cursor(0)
    if node and node:type() ~= 'argument_list' then
        -- Find parent `call` node
        while node and node:type() ~= 'call' do
            node = node:parent()
        end
        assert(node, 'No parent node of type "call"')
        -- Retrieve `argument_list` node via `field(…)`
        node = node:field('arguments') ---@type: table<integer, TSNode>
        assert(#node == 1, 'There are more than 1 "arguments" fields for this node, s. :InspectTree')
        -- Assign node
        node = node[1]
    end

    assert(node, 'No "argument_list" node found')

    -- Append `,` to last argument in the argument_list,
    -- ie. before the closing `)`
    local node_text = ts.get_node_text(node, bufnr):gsub('%)$', ',)')
    local start_row, start_col, end_row, end_col = node:range()
    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { node_text })
    vim.cmd.write()
end

vim.keymap.set('n', '<LocalLeader>f', function()
    format_function_call()
end, {
    desc = '[f]ormat call node'
})

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
