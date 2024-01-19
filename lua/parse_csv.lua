-- TODO: Pass path in any option table <19-01-2024>
local filename = '/home/philipp/programmieren/recipe-selector/res/ingredient_category_url.csv'

-- Function to parse CSV file and return a table of tables
local file = assert(io.open(filename, "r"), "Error opening file: " .. filename)
local result = {}

for line in file:lines() do
    local name, category, url = line:match("([^,]+),([^,]+),([^,]+)")

    -- Check if all fields are present
    if name and category and url then
        table.insert(result, { ingredient = name, category = category, url = url })
    else
        print("Skipping invalid line:", line)
    end
end
file:close()

return result
