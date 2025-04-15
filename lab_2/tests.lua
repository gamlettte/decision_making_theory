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
local test_runner = require("test_runner")

---@type test_runner
local tr = test_runner.new()

tr:add_test_case("wald_evaluation_1", function()
    assert(evaluation_methods.wald_evaluation(
        {
            {0, -1},
            {0, 0},
        }) == 2)
end)

tr:add_test_case("wald_evaluation_2", function()
    assert(evaluation_methods.wald_evaluation(
        {
            {0, 0},
            {-1, 0},
        }) == 1)
end)

tr:add_test_case("wald_evaluation_3", function()
    assert(evaluation_methods.wald_evaluation(
        {
            {5, -9},
            {1, -5},
        }) == 2)
end)

tr:add_test_case("savage_evaluation_1", function()
    assert(evaluation_methods.savage_evaluation(
        {
            {5, -9},
            {1, -5},
        }) == 1)
end)

tr:add_test_case("savage_evaluation_2", function()
    assert(evaluation_methods.savage_evaluation(
        {
            {-4, 4, 12},
            {-2, 3, 8},
            {3,  2, 1},
        }) == 2)
end)



tr:evaluate()
