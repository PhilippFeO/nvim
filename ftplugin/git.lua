-- s `h usr_27.txt`

-- TODO: Nur die erste und die letzte Highlight-Gruppe werden verwendet – warum? <02-01-2024>

local colors = require("kanagawa.colors").setup()
local cp = colors.palette

-- highlight commit hash
vim.cmd [[highlight GitHash guifg=#DCA561]]
vim.cmd [[match GitHash /[0-9a-f]\{7}/]]

-- vim.cmd [[highlight GitGraphNode guifg=#cc0000]]
-- vim.cmd [[match GitGraphNode /\*/]]

-- Relative time of git commit
-- \d\d {minutes, hours, days, weeks, months. …} ago
-- vim.cmd [[highlight GitRelTime guifg=#7E9CD8]]
-- vim.cmd [[match GitRelTime /[0-9]\{1,2} \{1}[a-z]* ago/]]

-- Author name
vim.cmd [[highlight GitAuthor guifg=#76946A]]
vim.cmd [[match GitAuthor /PhilippFeO/]]

-- Branch pointer
-- vim.cmd [[highlight GitBranch guibg=#cc3300]]
-- vim.cmd [[match GitBranch /(.*)$/]]
