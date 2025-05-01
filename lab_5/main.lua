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


---@type string
local matrix_string = io.open("main_matrix.json", "r"):read("*a")

---@type table
local json_data = json.decode(matrix_string)


local function borda_evaluation(array)

    ---@type integer
    local candidates_number = #(array[1].ranking)

    ---@type { [string]: integer }
    local candidates_table = {}

    for _, candidate_name in ipairs(array[1].ranking) do
        candidates_table[candidate_name] = 0
    end

    for _, row in ipairs(array) do

        ---@type integer
        local votes = row.votes
        for place, candidate_name in ipairs(row.ranking) do

            ---@type integer
            local reverse_place = candidates_number - place

            ---@type integer
            local candidate_score = candidates_table[candidate_name]

            ---@type integer
            local new_candidate_score = candidate_score + reverse_place * votes

            candidates_table[candidate_name] = new_candidate_score
        end
    end

    local best_index, best_value = "not_found", -math.huge
    for index, value in pairs(candidates_table) do
        if value > best_value then
            best_index = index
            best_value = value
        end
    end
    return best_index
end


---@private
---@param rows integer
---@param columns integer
---@return integer[][]
---@nodiscard
local function get_empty_matrix(rows, columns)
    ---@type integer[][]
    local matrix = {}
    for _ = 1, rows, 1 do
        ---@type integer[]
        local row = {}
        for _ = 1, columns, 1 do
            table.insert(row, 0)
        end
        table.insert(matrix, row)
    end

    return matrix
end


local function condorcet_evaluation(array)

    ---@type integer
    local candidates_number = #(array[1].ranking)

    ---@type { [string]: integer }
    local candidates_table = {}
    for i, candidate_name in ipairs(array[1].ranking) do
        candidates_table[candidate_name] = i
    end

    ---@type integer[][]
    local preference_matrix = get_empty_matrix(candidates_number, candidates_number)
    for _, row in ipairs(array) do

        ---@type integer
        local votes = row.votes

        for ranking_place, candidate_name in ipairs(row.ranking) do

            ---@type integer
            local candidate_order_number = candidates_table[candidate_name]

            for i = ranking_place + 1, candidates_number, 1 do

                ---@type integer
                local lower_candidate_order_number = candidates_table[row.ranking[i]]

                preference_matrix[candidate_order_number][lower_candidate_order_number] =
                    preference_matrix[candidate_order_number][lower_candidate_order_number] + votes
            end
        end
    end

    for i = 1, candidates_number, 1 do
        print(table.concat(preference_matrix[i], " "))
    end

    ---@type integer[][]
    local condorcet_matrix = get_empty_matrix(candidates_number, candidates_number)

    for i = 1, candidates_number, 1 do
        for ii = 1, candidates_number, 1 do
            if preference_matrix[i][ii] > preference_matrix[ii][i] then
                condorcet_matrix[i][ii] = 1
            end
        end
    end

    for i = 1, candidates_number, 1 do
        print(table.concat(condorcet_matrix[i], " "))
    end

    ---@type integer
    local top_candidate_index = -1
    for row_index, row in ipairs(condorcet_matrix) do
        ---@type boolean
        local is_top_candidate_found = true
        for column_index, cell in ipairs(row) do
            if (column_index ~= row_index) and (cell ~= 1) then
                is_top_candidate_found = false
                break
            end
        end

        if is_top_candidate_found then
            top_candidate_index = row_index
            break
        end
    end

    local top_candidate_name = "not found"
    for index, value in pairs(candidates_table) do
        if value == top_candidate_index then
            top_candidate_name = index
            break
        end
    end
    return top_candidate_name
end

print("Condorcet evaluation result: " .. condorcet_evaluation(json_data))
print("Borda evaluation result: " .. borda_evaluation(json_data))
