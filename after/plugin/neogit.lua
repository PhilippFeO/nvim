-- o: Öffne Git-Repo im Browser
-- y: Öffne alle Revisions (Zweige (remote, loka), Tags, Stashes, …)
-- „Popups“ öffnen sich und bieten weitere Optionen für Befehl an.

local ngit = require("neogit.lib.git")
-- ngit.config.set('neogit.baseBranch', 'origin/dev') --get("neogit.baseBranch")

-- Does the following on a feature branch (Execute after PR was merged):
--  git fetch origin/main (with --prune, s. .gitconfig)
--  git checkout origin/main
--  git push origin --delete feature
--  git branch -d feature
local function final_cleanup(_)
  local remote = ngit.branch.upstream_remote()
  local current_branch = ngit.branch.current()
  local main_dev_branch
  if vim.fn.getcwd():find('kursverwaltung', 1, true) then
    main_dev_branch = 'dev'
  else
    main_dev_branch = 'main'
  end
  local upstream_mdb = ngit.branch.upstream(main_dev_branch)
  local result
  if remote and current_branch and upstream_mdb then
    print('Fetch from ' .. remote .. '/' .. main_dev_branch)
    -- Done with --prune, s. ~/.gitconfig
    ngit.fetch.fetch(remote, main_dev_branch)
    -- Or `checkout(main)`?
    print('Checkout ' .. upstream_mdb)
    ngit.branch.checkout(upstream_mdb)
    -- delete: append -d
    -- (remotes: append -r)
    -- => git branch -d -r NAME
    print('Delete ' .. remote .. '/' .. current_branch)
    result = ngit.cli.push.delete.remote(remote).to(current_branch).call({ await = true })
    if result:success() then
      print('Delete ' .. current_branch)
      ngit.cli.branch.delete.name(current_branch).call({ await = true })
    end
  end
end


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
  builders = {
    NeogitBranchPopup = function(builder)
      builder
          :new_action_group('My Actions')
          :action('f', 'Final Cleanup', final_cleanup)
    end,
  },
})


-- Must come after require('neogit').setup().
local kanagawa_colors = require("kanagawa.colors").setup().palette
vim.api.nvim_set_hl(0, 'NeogitSectionHeader', {
  fg = kanagawa_colors.dragonBlue,
  bold = true,
})
