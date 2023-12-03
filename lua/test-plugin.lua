GlobalVarTest = "Meine globale Variable"

local test_string2 = "2 Test-String"

local M = {}

M.say_hello = function()
    print("Hallo")
end

M.test_string = "Mein Test-String"

M.setup = function(opts)
    opts = opts or {}
    local test_string = opts.test_string or test_string2
    print("Wert: " .. test_string)
end

return M
