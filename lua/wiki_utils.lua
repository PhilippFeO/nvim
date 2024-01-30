local M = {}


-- Adds word under cursor as tag to a wiki.vim page.
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


-- Write the file name, fi. 'neovim highlight groups.md' as wiki tags, ':neovim:highlight:groups:' in the second line
-- (I do/need this quite frequently)
M.filename_as_tags = function()
  -- expand file name macro
  local file_name_spaces = vim.fn.expand('%:t:r')
  -- replace spaces by :
  local file_name_colon = file_name_spaces:gsub(' ', ':')
  -- pre- and append :
  file_name_colon = ':' .. file_name_colon .. ':'
  -- write wiki tags
  -- start=end implies inserting, otherwise contents are overwritten
  local adjusted_tag_line_nr = vim.g.tag_line_number - 1 -- indexing starts at 0
  vim.api.nvim_buf_set_lines(0, lua_adjusted_tag_line_nr, lua_adjusted_tag_line_nr, false, {
    file_name_colon,
    '',
  })
end


return M
