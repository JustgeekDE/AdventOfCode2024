print("Hello World")

function parseInput ( filename )
    local file = io.open(filename, "r")
    local ordering = {}
    local manuals = {}
    if file then
        for line in file:lines() do
            -- print(line) -- Print each line
            local num1, num2 = line:match("(%d+)|(%d+)")
            if num1 and num2 then
                num1 = tonumber(num1) -- Convert the first captured value to a number
                num2 = tonumber(num2) -- Convert the second captured value to a number
                -- print(num1, num2) -- Output: 47  53
                table.insert(ordering, {num1, num2})
            end
            
        end
        file:close()
    else
        print("Failed to open the file.")
    end
    return ordering, manuals
end

function findLeftOnlyValues(ordering)
    leftOnlies = {}
    for i, order in ipairs(ordering) do
        leftOnlies[order[1]] = true
    end
    for i, order in ipairs(ordering) do
        if leftOnlies[order[2]] then
            leftOnlies[order[2]] = nil
        end
    end

    result = {}
    for key, _ in pairs(leftOnlies) do
        table.insert(result, key)
    end

    return result
end

function removeLeftValue(ordering, value)
    for i = #ordering, 1, -1 do -- Iterate from the last element to the first
        if ordering[i][1] == value then
            table.remove(ordering, i) -- Safely remove the element
        end
    end
end


function createOrder(ordering) 
    resultOrder = {}
    while #ordering > 0 do
        leftOnlies = findLeftOnlyValues(ordering)
        for i, value in ipairs(leftOnlies) do
            table.insert(resultOrder, value)
            removeLeftValue(ordering, value)
        end
        print("New order ", table.concat(resultOrder, ", "))
    end
    return resultOrder    
end

ordering, manuals = parseInput("example.txt")
orderedList = createOrder(ordering)

