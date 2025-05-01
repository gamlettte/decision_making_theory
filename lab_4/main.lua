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

--- local evaluation_methods = require("evaluation_methods")

add_relative_path("../misc")
---@module json
local json = require("json")


---@alias case_t {probability: number, profit: number}
---@private
---@param case case_t
---@return number
---@nodiscard
local function calculate_case_profit(case)

    assert(type(case.profit) == "number")
    assert(type(case.probability) == "number")
    assert(case.probability >= 0 and case.probability <= 1)

    return case.profit * case.probability
end


---@alias decision_t {payoff: case_t[], price: number, duration: number}
---@private
---@param decision decision_t
---@return number
---@nodiscard
local function calculate_decision_profit(decision)

    assert(type(decision.price) == "number")
    assert(decision.price >= 0)
    assert(type(decision.duration) == "number")
    assert(decision.duration >= 0)
    assert(type(decision.payoff) == "table")

    local payoff_sum = 0
    for _, case in ipairs(decision.payoff) do
        payoff_sum = payoff_sum + calculate_case_profit(case)
    end

    payoff_sum = (payoff_sum * decision.duration - decision.price)

    return payoff_sum
end


---@alias array_t decision_t[]
---@private
---@param array array_t
---@return number
---@nodiscard
local function calculate_array_profit(array)

    assert(type(array) == "table")

    local payoff_sum = 0
    for _, case in ipairs(array) do
        payoff_sum = payoff_sum + calculate_decision_profit(case)
    end

    return payoff_sum
end


---@alias matrix_t {decision_array: array_t, probability: number}
---@private
---@param matrix matrix_t
---@return number
---@nodiscard
local function calculate_matrix_profit(matrix)

    assert(type(matrix) == "table")

    local payoff_sum = 0

    for _, scenario in ipairs(matrix) do
        assert(type(scenario.probability) == "number")
        assert(scenario.probability >= 0 and scenario.probability <= 1)
        assert(type(scenario.decision_array) == "table")

        payoff_sum = payoff_sum +
            (calculate_array_profit(scenario.decision_array)
                * scenario.probability)
    end

    return payoff_sum
end


---@private
---@param block `T`[][]
---@param evaluation_function fun(value: `T`[]): number
local function select_best(block, evaluation_function)
    local max_index, max_profit = 1, -math.huge
    for index, value in ipairs(block) do
        local profit = evaluation_function(value)
        if profit > max_profit then
            max_profit = profit
            max_index = index
        end
    end
    return max_index
end


---@type string
local matrix_string = io.open("main_matrix.json", "r"):read("*a")

---@type table
local json_data = json.decode(matrix_string)


print("immediate action expected payoff " .. calculate_matrix_profit(json_data.matrix_1))
print("year delay expected payoff " .. calculate_matrix_profit(json_data.matrix_2))

---@type matrix_t[]
local data_block = {
    json_data.matrix_1,
    json_data.matrix_2
}

local best_matrix_index = select_best(data_block, calculate_matrix_profit)
print("best global decision " .. best_matrix_index)

print("best local decision " .. select_best(data_block[best_matrix_index], calculate_array_profit))
print("s " .. type(data_block[best_matrix_index][1].decision_array))
print(calculate_array_profit(json_data.matrix_1[1].decision_array))
