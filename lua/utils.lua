-- Sadly, this function is currently only used in dap-keymaps.lua, because nmap() in lua-keymaps.lua and man() in gitsigns.lua are slightly different
local nmap = function(desc_prefix)
  local t = function(keys, func, desc)
    if desc then
      desc = desc_prefix .. ': ' .. desc
    end

    vim.keymap.set('n', keys, func, { desc = desc })
  end
  return t
end

-- `h nvim_open_win()`
-- Source: https://en.wikipedia.org/wiki/Box-drawing_character > Symbols for Legacy Computing > U+1FB7x
-- I don't like the thin horitontals but there aren't better box drawing characters out there.
-- Other have their edge in the center which decreases the distance to the text and leaves area
-- "outside" of the border colored according to `h FloatBorder` which looks odd.
local border = {}
if IS_WORK_MACHINE then
  border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' }
else
  border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }
end


return {
  nmap = nmap,
  border = border,
}
