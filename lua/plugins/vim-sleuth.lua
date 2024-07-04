return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  init = function()
    -- Somehow nvim started to set `tabstop` to 8 in .tex files.
    -- This option disables the vim-sleuth plugin for .tex files, `tabstop` is now 4 again.
    vim.g.sleuth_tex_heuristics = false
    -- Otherwise inconsistencies emerge because I manually set tabstop=2 in ftplugin/markdown.lua
    vim.g.sleuth_markdown_heuristics = false
  end,
}
