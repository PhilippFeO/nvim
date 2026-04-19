-- o: Öffne Git-Repo im Browser
-- y: Öffne alle Revisions (Zweige (remote, loka), Tags, Stashes, …)
-- „Popups“ öffnen sich und bieten weitere Optionen für Befehl an.

require('neogit').setup({
  cmd = "Neogit",
  kind = "floating",
  graph_style = 'kitty',
  disable_line_numbers = false,
  disable_relative_line_numbers = false,
  commit_editor = {
    kind = 'floating',
    spell_check = false,
  },
  mappings = {
    status = {
      ['='] = 'Toggle',
    },
  },
  sections = {
    stashes = {
      folded = false,
      hidden = false,
    },
    unpulled_upstream = {
      folded = false,
      hidden = false,
    },
    recent = {
      folded = false,
      hidden = false,
    },
    rebase = {
      folded = false,
      hidden = false,
    },
  },
})


local kanagawa_colors = require("kanagawa.colors").setup().palette
vim.api.nvim_set_hl(0, 'NeogitSectionHeader', {
  fg = kanagawa_colors.dragonBlue,
  bold = true,
})
