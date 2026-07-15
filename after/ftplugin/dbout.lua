-- vim-dadbod-ui opens query results via `:DB`, which uses `pedit` (preview window)
-- when no bang is given. That window's height defaults to 'previewheight' (12),
-- not anything vim-dadbod(-ui) exposes -- resize it here instead.
vim.cmd('resize ' .. math.floor(vim.o.lines * 0.5))
