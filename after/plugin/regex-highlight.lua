local palette = require('kanagawa.colors').setup({ theme = 'wave' }).palette

local function set_regex_highlights()
  vim.api.nvim_set_hl(0, '@string.escape.regex',        { fg = palette.springGreen })
  vim.api.nvim_set_hl(0, '@string.regexp.regex',        { fg = palette.oldWhite })
  vim.api.nvim_set_hl(0, '@operator.regex',             { fg = palette.oniViolet })
  vim.api.nvim_set_hl(0, '@punctuation.bracket.regex',  { fg = palette.crystalBlue })
  vim.api.nvim_set_hl(0, '@punctuation.delimiter.regex', { fg = palette.autumnRed })
  vim.api.nvim_set_hl(0, '@constant.regex',             { fg = palette.carpYellow })
  vim.api.nvim_set_hl(0, '@number.regex',               { fg = palette.sakuraPink })
  vim.api.nvim_set_hl(0, '@property.regex',             { fg = palette.waveAqua2 })
  vim.api.nvim_set_hl(0, '@variable.builtin.regex',     { fg = palette.surimiOrange })
end

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = set_regex_highlights,
})

set_regex_highlights()
