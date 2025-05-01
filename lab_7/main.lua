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


---@private
---@param matrix number[][]
---@return integer
---@nodiscard
local function min_max(matrix)

    ---@type number[]
    local min_array = {}
    for row_index, row in ipairs(matrix) do
        local min_value = math.huge
        for cell_index, cell in ipairs(row) do
            if cell < min_value then
                min_value = cell
            end
        end
        table.insert(min_array, min_value)
    end

    return get_largest_value_index(min_array)
end


local function print_simplified_matrix(matrix)
    ---@type boolean[]
    local rows_used = {}
    for i = 1, #matrix, 1 do table.insert(rows_used, true) end

    for row_index_1, row_1 in ipairs(matrix) do
        for row_index_2, row_2 in ipairs(matrix) do
            if row_index_1 ~= row_index_2 then
                local is_row_2_obsolete = true
                for i = 1, #row_1, 1 do
                    if row_1[i] < row_2[i] then
                        is_row_2_obsolete = false
                        break
                    end
                end
                if is_row_2_obsolete then
                    rows_used[row_index_2] = false
                end
            end
        end
    end

    ---@type boolean[]
    local columns_used = {}
    for i = 1, #matrix[1], 1 do table.insert(columns_used, true) end

    for column_index_1 = 1, #matrix[1], 1 do
        for column_index_2 = 1, #matrix[column_index_1], 1 do
            if column_index_1 ~= column_index_2 then
                local column_index_2_obsolete = true
                for i = 1, column_index_1, 1 do
                    if matrix[i][column_index_1] < matrix[i][column_index_2] then
                        column_index_2_obsolete = false
                    end
                end
                if column_index_2_obsolete then
                    columns_used[column_index_2] = false
                end
            end
        end
    end

    ---@type number[][]
    local simplified_matrix = {}
    for index, row in ipairs(matrix) do
        if rows_used[index] then
            table.insert(simplified_matrix, row)
        end
    end

    for i = #simplified_matrix[1], 1, -1 do -- to escape table index shift problems
        if columns_used[i] == false then
            for ii = 1, #simplified_matrix, 1 do
                table.remove(simplified_matrix[ii], i)
            end
        end
    end

    print("simplified_matrix")
    for index, value in ipairs(simplified_matrix) do
        print(table.concat(value, " "))
    end
    print("simplified_matrix end")
end

---@type string
local matrix_string = io.open("main_matrix.json", "r"):read("*a")
print(matrix_string)

---@type table
local json_data = json.decode(matrix_string)

print("best strategy: " .. min_max(json_data))

print_simplified_matrix(json_data)
