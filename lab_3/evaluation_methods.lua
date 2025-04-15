---@private
---@param array number[]
---@return integer index of largest number
---@nodiscard
local function get_largest_value_index(array)

    ---@type integer, number
    local largest_index, largest_value = 0, -math.huge

    for index, value in ipairs(array) do
        if value > largest_value then
            largest_value = value
            largest_index = index
        end
    end

    return largest_index
end


---@private
---@param matrix number[][]
---@param probability_vector number[]
---@return number[] evaluation_vector
local function get_evaluation_vector(matrix, probability_vector)

    ---@type number[]
    local evaluation_vector = {}

    for i = 1, #matrix, 1 do
        ---@type number
        local sum = 0
        for ii = 1, #matrix, 1 do
            sum = sum + matrix[i][ii] * probability_vector[ii]
        end
        table.insert(evaluation_vector, sum)
    end

    return evaluation_vector
end



---@private
---@param matrix number[][]
---@param probability_vector number[]
---@return integer index of the optimal alternative
local function bayes_laplace_evaluation(matrix, probability_vector)

    ---@type number[]
    local evaluation_vector = get_evaluation_vector(matrix, probability_vector)

    return get_largest_value_index(evaluation_vector)
end


---@private
---@param matrix number[][]
---@param probability_vector number[]
---@param alpha number combination coefficient
---@return integer index of the optimal alternative
local function hodges_lehmann_evaluation(matrix, probability_vector, alpha)

    assert(alpha <= 1 and alpha >= 0)

    ---@type number[]
    local evaluation_vector = get_evaluation_vector(matrix, probability_vector)

    ---@type number[]
    local worst_payoff_array = {}
    for i = 1, #matrix, 1 do
        worst_payoff_array[i] = math.huge
    end

    for row_index, row in ipairs(matrix) do
        for _, value in ipairs(row) do
            if worst_payoff_array[row_index] > value then
                worst_payoff_array[row_index] = value
            end
        end
    end

    ---@type number[]
    local result_vector = {}
    for i = 1, #evaluation_vector, 1 do
        table.insert(result_vector, 
            evaluation_vector[i] * alpha + worst_payoff_array[i] * (1 - alpha))
    end

    return get_largest_value_index(result_vector)
end

---@private
---@param matrix integer[][]
---@return integer index of the optimal alternative
local function wald_evaluation(matrix)

    ---@type number[]
    local worst_payoff_array = {}
    for i = 1, #matrix, 1 do
        worst_payoff_array[i] = math.huge
    end

    for row_index, row in ipairs(matrix) do
        for _, value in ipairs(row) do
            if worst_payoff_array[row_index] > value then
                worst_payoff_array[row_index] = value
            end
        end
    end

    return get_largest_value_index(worst_payoff_array)
end

---@private
---@param matrix number[][]
---@param probability_vector number[]
---@return integer index of the optimal alternative
local function germeyer_evaluation(matrix, probability_vector)

    ---@type number[]
    local best_payoff_array = {}
    for i = 1, #matrix, 1 do
        best_payoff_array[i] = -math.huge
    end

    for _, row in ipairs(matrix) do
        for column_index, value in ipairs(row) do
            if best_payoff_array[column_index] < value then
                best_payoff_array[column_index] = value
            end
        end
    end

    ---@type number[][]
    local regret_matrix = {}
    for i = 1, #matrix, 1 do
        ---@type number[]
        local row = {}
        for ii = 1, #matrix, 1 do
            table.insert(row, probability_vector[ii] * (best_payoff_array[ii] - matrix[i][ii]))
        end
        table.insert(regret_matrix, row)
    end

    return wald_evaluation(regret_matrix)
end


local evaluation_methods = {
    bayes_laplace_evaluation = bayes_laplace_evaluation,
    hodges_lehmann_evaluation = hodges_lehmann_evaluation,
    germeyer_evaluation = germeyer_evaluation,
}

return evaluation_methods
