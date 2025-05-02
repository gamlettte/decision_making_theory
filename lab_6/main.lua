---@package
---@param dir string
---@return nil
local function add_relative_path(dir)
    local spath =
        debug.getinfo(1, 'S').source
        :sub(2)
        :gsub("^([^/])", "./%1")
        :gsub("[^/]*$", "")
    dir = dir and (dir .. "/") or ""
    spath = spath .. dir
    package.path = spath .. "?.lua;"
        .. spath .. "?/init.lua"
        .. package.path
end

add_relative_path("../misc")
---@module json
local json = require("json")


---@private
---@param vector number[]
---@return integer index of largest number
---@nodiscard
local function get_largest_value_index(vector)
    ---@type integer, number
    local largest_index, largest_value = 0, -math.huge

    for index, value in ipairs(vector) do
        if value > largest_value then
            largest_value = value
            largest_index = index
        end
    end

    return largest_index
end


---@type string
local matrix_string = io.open("main_matrix.json", "r"):read("*a")
print(matrix_string)

---@type table
local json_data = json.decode(matrix_string)


---@type table
local expert_evaluation_matrix = json_data.expert_evaluation_matrix

---@type table
local weight_dictionary = json_data.weight_dictionary

setmetatable(weight_dictionary,
    {
        __index =
        {
            len = function(dictionary)
                local increment = 0
                for _ in pairs(dictionary) do
                    increment = increment + 1
                end
                return increment
            end
        }
    }
)

---@type integer
local criteria_count = weight_dictionary:len()

---@type number[]
local evaluation_vector = {}
for _ = 1, criteria_count, 1 do table.insert(evaluation_vector, 0) end

for criterion_name, criterion_weight in pairs(weight_dictionary) do
    for object_index,
    evaluation in ipairs(expert_evaluation_matrix[criterion_name]) do
        evaluation_vector[object_index]
        = evaluation_vector[object_index] + (evaluation * criterion_weight)
    end
end

for index, value in ipairs(evaluation_vector) do
    print("car #" .. index .. " gets " .. value .. " points")
end

print("best car is: ", get_largest_value_index(evaluation_vector))
