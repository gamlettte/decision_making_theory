---@private
---@param matrix integer[][]
---@return nil
local function verify_matrix(matrix)

    ---@type integer
    local matrix_size = #matrix

    for index, value in ipairs(matrix) do
        assert(#value == matrix_size,
            "matrix is not square: h = " .. matrix_size ..
            ", w[".. index .."] =" .. #value)
    end
end


---@private
---@param matrix integer[][]
---@return boolean
---@nodiscard
local function is_matrix_reflective(matrix)

    verify_matrix(matrix)

    ---@type boolean
    local is_reflective = true

    for i = 1, #matrix, 1 do
        if matrix[i][i] == 0 then
            is_reflective = false
            break
        end
    end

    return is_reflective
end


---@private
---@param matrix integer[][]
---@return boolean
---@nodiscard
local function is_matrix_antireflective(matrix)

    verify_matrix(matrix)

    ---@type boolean
    local is_antireflective = true

    for i = 1, #matrix, 1 do
        if matrix[i][i] == 1 then
            is_antireflective = false
            break
        end
    end

    return is_antireflective
end


---@private
---@param matrix integer[][]
---@return boolean
---@nodiscard
local function is_matrix_symmetric(matrix)

    verify_matrix(matrix)

    ---@type boolean
    local is_symmetric = true

    for i = 1, #matrix, 1 do
        for ii = i, #matrix, 1 do
            if matrix[i][ii] ~= matrix[ii][i] then
                is_symmetric = false
                break
            end
        end
    end

    return is_symmetric
end


---@private
---@param matrix integer[][]
---@return boolean
---@nodiscard
local function is_matrix_antisymmetric(matrix)

    verify_matrix(matrix)

    ---@type boolean
    local is_antisymmetric = true

    for i = 1, #matrix, 1 do
        for ii = i + 1, #matrix, 1 do
            if matrix[i][ii] == matrix[ii][i] then
                is_antisymmetric = false
                break
            end
        end
    end

    return is_antisymmetric
end


---@private
---@param matrix integer[][]
---@return boolean
---@nodiscard
local function is_matrix_asymmetric(matrix)

    verify_matrix(matrix)

    ---@type boolean
    local is_asymmetric = true

    for i = 1, #matrix, 1 do
        for ii = i, #matrix, 1 do
            if matrix[i][ii] ~= matrix[ii][i] then
                is_asymmetric = false
                break
            end
        end
    end

    return is_asymmetric
end


---@private
---@param matrix integer[][]
---@return boolean
---@nodiscard
local function is_matrix_transitive(matrix)

    verify_matrix(matrix)

    ---@type boolean
    local is_transitive = true

    for i = 1, #matrix, 1 do
        for ii = 1, #matrix, 1 do
            if matrix[i][ii] == 1 then
                for iii = 1, #matrix, 1 do
                    if matrix[ii][iii] == 1 and matrix[i][iii] == 0 then
                        is_transitive = false
                        break
                    end
                end
            end
        end
    end

    return is_transitive
end


local relations_methods = {
    is_matrix_reflective = is_matrix_reflective,
    is_matrix_antireflective = is_matrix_antireflective,
    is_matrix_symmetric = is_matrix_symmetric,
    is_matrix_antisymmetric = is_matrix_antisymmetric,
    is_matrix_asymmetric = is_matrix_asymmetric,
    is_matrix_transitive = is_matrix_transitive
}

return relations_methods
