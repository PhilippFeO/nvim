local user_command = vim.api.nvim_create_user_command
user_command('CorrectMD', 'set hlsearch | %s/` \\(.\\{-}\\)`/ `\\1`/gc', {
    desc = 'WORD` CODE` -> WORD `CODE`',
})

-- By executing :KL the light/dark version of the kanagawa colorscheme is toggled
local kanagawa_toggle = true
user_command('KL', function(_)
    if kanagawa_toggle then
        kanagawa_toggle = not kanagawa_toggle
        vim.cmd('colorscheme kanagawa-lotus')
    else
        kanagawa_toggle = not kanagawa_toggle
        vim.cmd('colorscheme kanagawa')
    end
end, { desc = ':colorscheme kanagawa-lotus' })

--- Jump to the last valid quickfix entry
--- Python error messages produce multiple valid quickfix entries. With this function it is possible to jump to the last (and often the most relevant) one.
local jump_to_last_valid_qf_entry = function()
    local qflist = vim.fn.getqflist()
    if #qflist > 0 then
        -- Find last valid quickfix entry
        for i = #qflist, 1, -1 do
            local qf_entry = qflist[i]
            local valid = qf_entry.valid
            if valid == 1 then
                -- print(vim.inspect(qf_entry))
                local bufnr = qf_entry.bufnr
                local bufname = vim.fn.bufname(bufnr)
                -- Dont jump to error in installed packages
                if string.find(bufname, "site-packages", 1, true) == nil then
                    local lnum = qf_entry.lnum
                    -- local text = qf_entry.text

                    -- Create new tab and set it's buffer to the buffer where the error resides
                    -- (nvim_buf_get_lines() doesn't work with unlisted buffers and sometime, esp. after starting nvim, the buffer hasn't been listed/opened, wherefore nvim_buf_get_lines() fails)
                    vim.cmd('tabnew | buffer' .. bufnr)

                    -- Get the specified line (line_number is 1-based)
                    -- Convert to 0-based index
                    -- Doesn't work with unlisted buffers :( => buffer was openend in a new tab beforehand
                    local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]

                    -- Find the first non-whitespace character
                    -- %S matches any non-whitespace character
                    local col_first_non_whitespace = line:find("%S") - 1

                    -- Switch to the specified buffer, line and row
                    vim.api.nvim_set_current_buf(qf_entry.bufnr)
                    vim.api.nvim_win_set_cursor(0, { lnum, col_first_non_whitespace })
                    return
                end
            end
        end
    else
        print("Quickfix list is empty.")
    end
end

vim.api.nvim_create_user_command(
    'LastQuickfix',
    jump_to_last_valid_qf_entry,
    {
        -- Whether command can be followed by a '|' (to allow chaining)
        bar = true
    }
)
