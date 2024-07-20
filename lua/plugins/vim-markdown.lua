return {
  'preservim/vim-markdown',
  init = function()
    vim.g.vim_markdown_conceal = true
    vim.g.vim_markdown_math = 1
    vim.g.vim_markdown_folding_disabled = true
    vim.g.vim_markdown_toc_autofit = true   -- :Toc, :Tocv, :Toct
    vim.g.vim_markdown_strikethrough = true -- two ~ for strikethrough
    vim.g.vim_markdown_autowrite = true     -- write when following link
    vim.g.vim_markdown_follow_anchor = true -- follow anchored links
    vim.g.vim_markdown_auto_insert_bullets = 0
    vim.g.vim_markdown_new_list_item_indent = 0
  end,
  ft = 'markdown',
}
