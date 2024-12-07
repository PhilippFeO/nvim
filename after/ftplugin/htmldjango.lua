local colors = require("kanagawa.colors").setup()
local cp = colors.palette
local highlight = vim.api.nvim_set_hl
local WAVE_BLUE = '#65AD99'

highlight(0, '@punctuation.bracket.htmldjango', { fg = cp.sakuraPink, })
highlight(0, '@function.htmldjango', { fg = WAVE_BLUE })
