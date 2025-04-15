---@package
---@param dir string 
---@return nil
local function add_relative_path(dir)
  local spath =
      debug.getinfo(1,'S').source
        :sub(2)
        :gsub("^([^/])","./%1")
        :gsub("[^/]*$","")
  dir=dir and (dir.."/") or ""
  spath = spath..dir
  package.path = spath.."?.lua;"
               ..spath.."?/init.lua"
               ..package.path
end

local evaluation_methods = require("evaluation_methods")

add_relative_path("../misc")
---@module json
local json = require("json")


---@type string
local matrix_string = io.open("main_matrix.json", "r"):read("*a")

---@type table
local json_data = json.decode(matrix_string)

---@type integer[][]
local matrix = json_data.matrix

---@number[]
local probability_vector = json_data.probability_vector
assert(probability_vector ~= nil)

for index, value in pairs(matrix) do
    print(tostring(index) .. " ~ " .. table.concat(value, " "))
end

print(table.concat(probability_vector, " "))


print("bayes-laplace evaluation index: ".. evaluation_methods.bayes_laplace_evaluation(matrix, probability_vector))
print("hodges-lehmann evaluation index: ".. evaluation_methods.hodges_lehmann_evaluation(matrix, probability_vector, 1))
print("hodges-lehmann evaluation index: ".. evaluation_methods.germeyer_evaluation(matrix, probability_vector))
