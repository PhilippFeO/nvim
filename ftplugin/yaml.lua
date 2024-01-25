-- Macro, dann N@REGISTER, mit :norm klappt's nicht, weil neue Zeilen hinzukommen, auch wenn man im Makro jj am Ende tippt
-- Replace 'first,second' with '  - name: first\n    quantity: second'
-- Only used for wirting recipes
local transform_to_yaml = function()
    local line = vim.api.nvim_get_current_line()
    local row = {}
    for value in line:gmatch("[^,]+") do
        table.insert(row, value)
    end
    local yaml_name = string.format('  - name: %s', row[2])
    local yaml_quantity = string.format('    quantity: %s', row[1])
    local linenr = vim.api.nvim_win_get_cursor(0)[1]
    -- Although line numbering starts with 1, a 0-based index is necessary, s. `h nvim_buf_set_lines`
    local adjusted_linenr = linenr - 1
    vim.api.nvim_buf_set_lines(0, adjusted_linenr, adjusted_linenr + 1, true, {
        yaml_name,
        yaml_quantity
    })
end

vim.api.nvim_buf_create_user_command(0, 'ToYaml', transform_to_yaml, {})
