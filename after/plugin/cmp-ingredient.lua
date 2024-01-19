--[[
- Mechanik, die CSV-Datei liest hier einfügen
- Im Konstruktor CSV Datei lesen
- Funktion als eigene Lua-Datei
- Alles in eigenes Plugin -> ich weiß im Moment nicht, wie man Plugin strukturiert
    - wasl. alles in lua/PLUGIN-NAME ablegen
--]]
local icu = require('parse_csv')

local items = {}

for _, icu_entry in ipairs(icu) do
    table.insert(items, {
        label = icu_entry.ingredient,
        documentation = {
            kind = "markdown",
            value = string.format("%s\n\n## Category\n%s\n\nURL:\n%s", icu_entry.ingredient, icu_entry.category,
                icu_entry.url)
        }
    })
end


local source = {}

source.new = function()
    local self = setmetatable({ cache = {} }, { __index = source })

    return self
end

source.option = function(_, params)
    return params.options
end


-- Enable only in `yaml` buffers
-- s. `h cmp-develop`
-- source.is_available = function(params)
--      print(params.options.lorem) -- funktioniert
source.is_available = function()
    print(vim.bo.filetype)
    return vim.bo.filetype == 'yaml' or vim.bo.filetype == 'yml'
end

-- Wenn erster Parameter `self` ist (hier `_`, weil ich `self` nicht verwende), dann ist damit die Tabelle, in diesem Fall `source` gemeint
source.complete = function(self, params, callback)
    -- params "options attribute aus nvim-cmp steht in params"
    -- print(params.options.lorem) -- Funktioniert
    callback(items)
end

require("cmp").register_source("ingredients", source.new())
