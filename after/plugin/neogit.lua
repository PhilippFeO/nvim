-- o: Öffne Git-Repo im Browser
-- y: Öffne alle Revisions (Zweige (remote, loka), Tags, Stashes, …)
-- „Popups“ öffnen sich und bieten weitere Optionen für Befehl an.

local ngit = require("neogit.lib.git")
local notification = require("neogit.lib.notification")
-- ngit.config.set('neogit.baseBranch', 'origin/dev') --get("neogit.baseBranch")

-- Does the following on a feature branch (Execute after PR was merged):
--  git fetch origin/main (with --prune, s. .gitconfig)
--  git checkout origin/main
--  git push origin --delete feature
--  git branch -d feature
local function remove_feature_branch(_)
  local remote = ngit.branch.upstream_remote()
  local current_branch = ngit.branch.current()
  local main_dev_branch
  local root_dir = require 'lspconfig.util'.root_pattern('.git')('.')
  if root_dir ~= nil then
    if string.find(root_dir, 'kursverwaltung', 1, true) ~= nil then
      main_dev_branch = 'dev'
    else
      main_dev_branch = 'main'
    end
  end
  -- Built directly instead of via `ngit.branch.upstream(main_dev_branch)`:
  -- that resolves `{main_dev_branch}@{upstream}` through git, which requires
  -- a pre-existing local branch with valid upstream tracking configured --
  -- and returns nil (silently no-opping this whole function via the guard
  -- below) whenever that tracking is missing or stale.
  local upstream_mdb = remote and (remote .. '/' .. main_dev_branch)
  local result
  if remote and current_branch and upstream_mdb then
    print('Fetch from ' .. remote .. '/' .. main_dev_branch)
    -- Done with --prune, s. ~/.gitconfig
    ngit.fetch.fetch(remote, main_dev_branch)
    print('Checkout ' .. upstream_mdb)
    ngit.branch.checkout(upstream_mdb)
    -- delete: append -d
    -- (remotes: append -r)
    -- => git branch -d -r NAME
    print('Delete ' .. remote .. '/' .. current_branch)
    -- Check if remote counterpart exists
    if ngit.fetch.fetch(remote, current_branch):success() then
      result = ngit.cli.push.delete.remote(remote).to(current_branch).call({ await = true })
      if result:success() then
        print('Delete ' .. current_branch)
        -- Force-delete unconditionally (`-D`, no ancestry check, no prompt):
        -- this action only runs after a PR merge, and squash/rebase-merged PRs
        -- would otherwise trip `ngit.branch.delete()`'s "unmerged" confirmation
        -- every single time -- if you're running this, you've already decided
        -- the branch is done for.
        local delete_result = ngit.cli.branch.delete.force.name(current_branch).call({ await = true })
        if delete_result:success() then
          notification.info('Deleted ' .. current_branch .. ' (local + remote)')
        else
          notification.error('Deleted remote branch, but failed to delete local branch ' .. current_branch)
        end
      else
        notification.error('Failed to delete remote branch ' .. remote .. '/' .. current_branch)
      end
    end
  end
end


require('neogit').setup({
  -- TODO(Philipp): Should work by default, https://github.com/NeogitOrg/neogit/issues/1964 <26-06-2026>
  treesitter_diff_highlight = true,
  cmd = "Neogit",
  kind = "floating",
  graph_style = IS_WORK_MACHINE and 'unicode' or 'kitty',
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
          :action('f', 'Remove Feature Branch', remove_feature_branch)
    end,
  },
})


-- Must come after require('neogit').setup().
local kanagawa_colors = require("kanagawa.colors").setup().palette
vim.api.nvim_set_hl(0, 'NeogitSectionHeader', {
  fg = kanagawa_colors.dragonBlue,
  bold = true,
})
