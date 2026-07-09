vim.g.db_ui_table_helpers = {
  postgresql = {
    Count = 'select count(*) from "{schema}"."{table}"'
  }
}

vim.g.db_ui_auto_execute_table_helpers = true
-- width of db list/drawer
vim.g.db_ui_winwidth = 50
