return {
  'lervag/wiki.vim',
  -- Man muss wiki <leader>ww am besten im Verzeichnis selbst aufrufen
  init = function()
    vim.g.tag_line_number = 2 -- NO official wiki.vim variable, I have introduced it for `wiki_utils.add_tag()`
    vim.g.wiki_root = '~/wiki'
    vim.g.wiki_index_name = 'Notizen'
    vim.g.wiki_filetypes = { 'md' }
    vim.g.wiki_link_extension = '.md'
    vim.g.wiki_link_target_type = 'md'
    vim.g.wiki_global_load = false
    vim.g.wiki_write_on_nav = true
    vim.g.wiki_tag_scan_num_lines = vim.g.tag_line_number
    vim.g.wiki_select_method = {
      tags = require("wiki.telescope").tags,
      links = require("wiki.telescope").links,
      -- pages = require("wiki.ui_select").pages,
      -- toc = require("wiki.ui_select").toc,
    }
  end,
  -- ft = { 'markdown', 'wiki' } -- doesn't work
}
