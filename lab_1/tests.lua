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

local relations_methods = require("relations_methods")

add_relative_path("../misc")
local test_runner = require("test_runner")

---@type test_runner
local tr = test_runner.new()


tr:add_test_case("is_matrix_reflective_1", function()
    assert(relations_methods.is_matrix_reflective(
        {
            {1},
        }
    ) == true)
end)

tr:add_test_case("is_matrix_reflective_2", function()
    assert(relations_methods.is_matrix_reflective(
        {
            {0},
        }
    ) == false)
end)

tr:add_test_case("is_matrix_reflective_3", function()
    assert(relations_methods.is_matrix_reflective(
        {
            {1, 0},
            {0, 1},
        }
    ) == true)
end)

tr:add_test_case("is_matrix_reflective_4", function()
    assert(relations_methods.is_matrix_reflective(
        {
            {1, 0},
            {0, 0},
        }
    ) == false)
end)


tr:add_test_case("is_matrix_antireflective_1", function ()
    assert(relations_methods.is_matrix_antireflective(
        {
            {1},
        }
    ) == false)
end)

tr:add_test_case("is_matrix_antireflective_2", function ()
    assert(relations_methods.is_matrix_antireflective(
        {
            {0},
        }
    ) == true)
end)

tr:add_test_case("is_matrix_antireflective_3", function ()
    assert(relations_methods.is_matrix_antireflective(
        {
            {1, 0},
            {0, 1},
        }
    ) == false)
end)

tr:add_test_case("is_matrix_antireflective_4", function ()
    assert(relations_methods.is_matrix_antireflective(
        {
            {1, 0},
            {0, 0},
        }
    ) == false)
end)


tr:add_test_case("is_matrix_symmetric_1", function()
    assert(relations_methods.is_matrix_symmetric(
        {
            {1},
        }
    ) == true)
end)

tr:add_test_case("is_matrix_symmetric_2", function()
    assert(relations_methods.is_matrix_symmetric(
        {
            {0},
        }
    ) == true)
end)

tr:add_test_case("is_matrix_symmetric_3", function()
    assert(relations_methods.is_matrix_symmetric(
        {
            {1, 0},
            {1, 1},
        }
    ) == false)
end)

tr:add_test_case("is_matrix_symmetric_4", function()
    assert(relations_methods.is_matrix_symmetric(
        {
            {1, 0},
            {0, 0},
        }
    ) == true)
end)


tr:add_test_case("is_matrix_antisymmetric_1", function()
    assert(relations_methods.is_matrix_antisymmetric(
        {
            {1},
        }
    ) == true)
end)

tr:add_test_case("is_matrix_antisymmetric_2", function()
    assert(relations_methods.is_matrix_antisymmetric(
        {
            {0},
        }
    ) == true)
end)

tr:add_test_case("is_matrix_antisymmetric_3", function()
    assert(relations_methods.is_matrix_antisymmetric(
        {
            {1, 0},
            {0, 1},
        }
    ) == false)
end)

tr:add_test_case("is_matrix_antisymmetric_4", function()
    assert(relations_methods.is_matrix_antisymmetric(
        {
            {1, 0},
            {0, 0},
        }
    ) == false)
end)

tr:add_test_case("is_matrix_antisymmetric_5", function()
    assert(relations_methods.is_matrix_antisymmetric(
        {
            {0, 0},
            {1, 0},
        }
    ) == true)
end)

tr:evaluate()
