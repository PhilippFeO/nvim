local actions = require 'telescope.actions'
local action_state = require "telescope.actions.state"
local action_set = require 'telescope.actions.set'
local utils = require "telescope.utils"


local M = {}

-- Open help tags and man pages in vertical split on default.
-- Code of `h attach_mappings` copied from `h telescope.builtin.help_tags`.
-- Only if block at the end of opts was changed.
-- Procedure found on 'https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#actions'
-- `open_win_default` should be in {'vert help', 'help', 'tab help'}
function attach_mappings_helper(picker, open_win_default)
  local f = function(prompt_bufnr)
    action_set.select:replace(function(_, cmd)
      local selection = action_state.get_selected_entry()
      if selection == nil then
        utils.__warn_no_selection(picker)
        return
      end

      actions.close(prompt_bufnr)
      if cmd == "default" then
        vim.cmd(string.format('%s help %s', open_win_default, selection.value))
      elseif cmd == "vertical" then   -- <C-v> opens vertically
        vim.cmd(string.format('vert help %s', selection.value))
      elseif cmd == "horizontal" then -- <C-x> opens horizontally
        vim.cmd(string.format('help %s', selection.value))
      elseif cmd == "tab" then        -- <C-t> opens in new tab
        vim.cmd(string.format('tab help %s', selection.value))
      else
        print(
          string.format(
            "open_win_default=%s. Should be in {'vert help', 'help', 'tab help'}.", open_win_default
          )
        )
      end
    end)

    return true
  end

  return { attach_mappings = f }
end

M.vsplit_help_tags = function() require('telescope.builtin').help_tags(attach_mappings_helper('builtin.help_tags', 'vert')) end
M.tab_man_pages = function() require('telescope.builtin').man_pages(attach_mappings_helper('builtin.man_pages', 'tab')) end

return M
