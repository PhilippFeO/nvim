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

local border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }

return {
  nmap = nmap,
  border = border,
}
