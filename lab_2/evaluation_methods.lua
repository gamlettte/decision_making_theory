---@private
---@param matrix integer[][]
---@return nil
local function verify_matrix(matrix)

    ---@type integer
    local matrix_size = #matrix

    for row_index, row in ipairs(matrix) do
        assert(#row == matrix_size,
            "matrix is not square: h = " .. matrix_size ..
            ", w[".. row_index .."] =" .. #row)
    end
end


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
---@param matrix integer[][]
---@return integer index of the optimal alternative
local function wald_evaluation(matrix)

    verify_matrix(matrix)

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
---@param matrix integer[][]
---@return integer index of the optimal alternative
local function savage_evaluation(matrix)

    verify_matrix(matrix)

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
            table.insert(row, best_payoff_array[ii] - matrix[i][ii])
        end
        table.insert(regret_matrix, row)
    end

    return wald_evaluation(regret_matrix)
end


---@private
---@param matrix integer[][]
---@return integer index of the optimal alternative
local function hurwitz_evaluation(matrix)

    verify_matrix(matrix)

    ---@type number
    local optimism_coefficient = 0.5

    ---@type number[]
    local payoff_array = {}
    for row_index, row in ipairs(matrix) do

        ---@type integer, number
        local best_column_index, best_column_value = 0, -math.huge

        ---@type integer, number
        local worst_column_index, worst_column_value = 0, math.huge

        for column_index, value in ipairs(row) do
            if value > best_column_value then
                best_column_value = value
                best_column_index = column_index
            end

            if value < worst_column_value then
                worst_column_value = value
                worst_column_index = column_index
            end
        end

        table.insert(payoff_array,
            optimism_coefficient * (best_column_value + worst_column_value))
    end

    return get_largest_value_index(payoff_array)
end


---@private
---@param matrix integer[][]
---@return integer index of the optimal alternative
local function laplace_evaluation(matrix)

    verify_matrix(matrix)

    ---@type number[]
    local expected_payoff = {}
    for row_index, row in ipairs(matrix) do
        ---@type number
        local row_sum = 0
        for column_index, value in ipairs(row) do
            row_sum = row_sum + value
        end
        table.insert(expected_payoff, row_sum)
    end

    return get_largest_value_index(expected_payoff)
end

local evaluation_methods = {
    wald_evaluation = wald_evaluation,
    savage_evaluation = savage_evaluation,
    hurwitz_evaluation = hurwitz_evaluation,
    laplace_evaluation = laplace_evaluation,
}

return evaluation_methods
