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

---@type integer[][]
local matrix = json.decode(matrix_string).matrix

for index, value in pairs(matrix) do
    print(tostring(index) .. " ~ " .. table.concat(value, " "))
end


print("wald evaluation index: ".. evaluation_methods.wald_evaluation(matrix))
print("savage evaluation index: ".. evaluation_methods.savage_evaluation(matrix))
print("hurwitz evaluation index: ".. evaluation_methods.hurwitz_evaluation(matrix))
print("laplace evaluation index: ".. evaluation_methods.laplace_evaluation(matrix))
