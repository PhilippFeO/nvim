local actions = require 'telescope.actions'
local action_state = require "telescope.actions.state"
local action_set = require 'telescope.actions.set'
local utils = require "telescope.utils"


local M = {}

-- Open help tags in vertical split on default.
-- Code of `h attach_mappings` copied from `h telescope.builtin.help_tags`.
-- Only if block at the end was changed.
-- Procedure found on 'https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#actions'
M.my_help_tags = function()
  print('lorem ipsum')
  local opts = {
    attach_mappings = function(prompt_bufnr)
      action_set.select:replace(function(_, cmd)
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.help_tags"
          return
        end

        actions.close(prompt_bufnr)
        print(cmd)
        if cmd == "default" then
          vim.cmd("vert help " .. selection.value)
        elseif cmd == "horizontal" then -- <C-x> opens horizontally
          vim.cmd("help " .. selection.value)
        elseif cmd == "tab" then        -- <C-t> opens in new tab
          vim.cmd("tab help " .. selection.value)
        end
      end)

      return true
    end,
  }
  require('telescope.builtin').help_tags(opts)
end

return M
