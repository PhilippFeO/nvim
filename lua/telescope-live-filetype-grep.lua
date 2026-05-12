-- https://www.youtube.com/watch?v=xdXE1tOT-qg
-- https://github.com/tjdevries/advent-of-nvim/blob/master/nvim/lua/config/telescope/multigrep.lua

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local conf = require "telescope.config".values

local M = {}

local live_filetype_grep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  -- executes finding asynchronously
  -- Look at source code to find out, what it does
  local finder = finders.new_async_job {
    -- We have to generate a command
    -- command_generator is used to find the results while typing
    -- prompt: the input for telescope
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      -- When typing '  ' (2 spaces), prompt/input is split and second part describes filetype
      local pieces = vim.split(prompt, "  ")
      local args = { "rg" }
      if pieces[1] then
        -- -e if multiple patterns are used for searching
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end

      -- after '  ', ie. the filetype
      if pieces[2] then
        -- -g use glob-pattern
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end

      -- Options to make rg print results diagestable for nvim
      ---@diagnostic disable-next-line: deprecated
      return vim.tbl_flatten {
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      }
    end,
    -- format lines
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers.new(opts, {
    -- finds the results
    finder = finder,
    -- Execute finder every 100ms
    debounce = 100,
    prompt_title = 'Filetype Aware Live Grep',
    -- get normal/default previewer
    previewer = conf.grep_previewer(opts),
    -- don't sort (it's already sorted)
    sorter = require("telescope.sorters").empty(),
  }):find()
end

M.live_filetype_grep = live_filetype_grep

return M
