local M = {}

-- Adds the word under the cursor as tag to a wiki.vim page.
M.add_tag = function()
  -- append colon for valid tag
  local word = vim.fn.expand('<cword>') .. ':'
  -- defined by myself in wiki.vim startup
  local tags_line_nr = vim.g.tag_line_number - 1
  -- calculate highest column
  local tags_line = vim.api.nvim_buf_get_lines(0, 1, 2, false)[1]
  local last_column = string.len(tags_line)
  -- set tag
  vim.api.nvim_buf_set_text(0, tags_line_nr, last_column, tags_line_nr, last_column, { word })
end

return M
