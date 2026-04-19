-- o: Öffne Git-Repo im Browser
-- y: Öffne alle Revisions (Zweige (remote, loka), Tags, Stashes, …)
-- „Popups“ öffnen sich und bieten weitere Optionen für Befehl an.

local neogit = require('neogit')
local ngit = require("neogit.lib.git")
-- local ngit = neogit.lib.git
-- local b = ngit.branch.current()
-- 'connected' Upstream branch
-- print(vim.inspect(ngit.branch.upstream(b)))
-- print(vim.inspect(ngit.cli.branch.delete.name('test')))
-- print(vim.inspect(ngit.cli.branch.delete.remotes.name('test').call({ await = true })))

-- Execute after PR was merged
--  - Fetches new main
--  - checks it out
--  - deletes feature branch it's remote counterpart
local function final_cleanup(_)
  local remote = ngit.branch.upstream_remote()
  local current_branch = ngit.branch.current()
  local main = ngit.branch.base_branch()
  local upstream_main = ngit.branch.upstream(main)
  local result
  if remote and current_branch and main and upstream_main then
    -- TODO(Philipp): Add --prune <19-04-2026>
    print('Fetch from "' .. remote .. main .. '"')
    ngit.fetch.fetch(remote, main)
    -- Oder `checkout(main)`?
    -- upstream_main, if pushing to main is permitted
    print('Checkout ' .. upstream_main)
    ngit.branch.checkout(upstream_main)
    -- delete: append -d
    -- remotes: append -r
    -- => git branch -d -r NAME
    result = ngit.cli.branch.delete.name(current_branch).call({ await = true })
    if result and result:success() or false then
      result = ngit.cli.branch.delete.remotes.name(remote .. '/' .. current_branch).call({ await = true })
    end
  end

  return result and result:success() or false

  -- -- You can access the popup state (enabled flags) like so:
  -- local cli_args = popup:get_arguments()
  --
  -- -- You can use Neogit's git abstraction for many common operations
  -- -- local git = require("neogit.lib.git")
  --
  -- -- The input library provides some helpful interfaces for getting user
  -- -- input
  -- local input = require("neogit.lib.input")
  -- local user_input = input.get_user_input("User-specified free text for the action")
  --
  -- vim.notify(
  --   "Hello from my custom action!\n"
  --   .. "CLI args: `" .. table.concat(cli_args, " ") .. "`\n"
  --   .. "User input: `" .. user_input .. "`")
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


local kanagawa_colors = require("kanagawa.colors").setup().palette
vim.api.nvim_set_hl(0, 'NeogitSectionHeader', {
  fg = kanagawa_colors.dragonBlue,
  bold = true,
})
