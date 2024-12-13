-- Loads RUNTIMEPATH/compiler/python.lua
vim.cmd.compiler('python')

local q = require 'vim.treesitter.query'

local ts_locals = require 'nvim-treesitter.locals'

print('hi')
local formatTS = function()
    local bufnr = 40
    local language_tree = vim.treesitter.get_parser(bufnr, 'python')
    local syntax_tree = language_tree:parse()
    local root = syntax_tree[1]:root()

    -- @… „Captures“
    -- Alle @… zusammen: „Match“
    -- Ein Match besteht aus mindestens einem Capture

    local query = vim.treesitter.query.parse('python',
        [[
            ;(argument_list) @al ;(#gsub! ".*" "7, 7")
            (argument_list) @al (#offset! @al)
            ;(call
            ;  function: (identifier) @fn_id ;(#eq? @fn_id "f")
            ;) @cl

        ]]
    )

    for _, captures, metadata in query:iter_matches(root, bufnr) do
        -- print(vim.inspect(captures))
        -- print(vim.inspect(getmetatable(captures)))
        -- print(vim.inspect(metadata))
        -- print(vim.treesitter.get_node_text(captures[1], bufnr))
    end

    for id, node, metadata, match in query:iter_captures(root, bufnr) do
        print(vim.treesitter.get_node_text(node, bufnr))
        -- print(vim.inspect(getmetatable(node)))
        --
        local s = {}

        for c in node:iter_children() do
            -- print(c,)
            table.insert(s, vim.treesitter.get_node_text(c, bufnr))
        end

        print(vim.inspect(s))


        -- Gibt den ganzen Scope, in dem der Knoten liegt zurück, also alle Eltern
        local scope = ts_locals.get_scope_tree(node, bufnr)
        print(vim.inspect(scope))
        for _, node in ipairs(scope) do
            print(node:type())
        end
        local line_s, col_s, line_e, col_e = node:range()
        print(node:range())
        -- local node_text = vim.treesitter.get_node_text(node, bufnr)
        -- local x = vim.split(node_text, ',')
        vim.api.nvim_buf_set_text(bufnr, line_s, col_s, line_e, col_e, s)
        -- print(vim.inspect(getmetatable(metadata)))
        -- print(vim.inspect(getmetatable(match)))
    end
end

-- formatTS()

vim.api.nvim_create_user_command(
    'FormatTS',
    formatTS,
    {}
)


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
