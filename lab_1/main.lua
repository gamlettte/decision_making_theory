---@module json
local json = require("json")

local relations_methods = require("relations_methods")

---@type string
local matrix_string = io.open("main_matrix.json", "r"):read("*a")

---@type integer[][]
local matrix = json.decode(matrix_string).matrix

for index, value in pairs(matrix) do

    print(tostring(index) .. " ~ " .. table.concat(value, " "))
end

print("is matrix reflective: " .. tostring(relations_methods.is_matrix_reflective(matrix)))
print("is matrix antireflective: " .. tostring(relations_methods.is_matrix_antireflective(matrix)))
print("is matrix symmetric: " .. tostring(relations_methods.is_matrix_symmetric(matrix)))
print("is matrix antisymmetric: " .. tostring(relations_methods.is_matrix_antisymmetric(matrix)))
print("is matrix transitive: " .. tostring(relations_methods.is_matrix_transitive(matrix)))
