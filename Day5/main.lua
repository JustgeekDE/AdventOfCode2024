print("Hello World")

function parseInput ( filename )
    local file = io.open(filename, "r")
    local ordering = {}
    local manuals = {}
    if file then
        for line in file:lines() do
            local num1, num2 = line:match("(%d+)|(%d+)")
            if num1 and num2 then
                num1 = tonumber(num1) 
                num2 = tonumber(num2)
                table.insert(ordering, {num1, num2})
            else
                if #line > 0 then
                    entry = {}
                    for num in string.gmatch(line, "%d+") do
                        table.insert(entry, tonumber(num))
                    end
                    -- print("Manual ", table.concat(entry, ", "))
                    table.insert(manuals, entry)
                end
            end
            
        end
        file:close()
    else
        print("Failed to open the file.")
    end
    return ordering, manuals
end

function getDictKeys(dict) 
    local keys = {} 
    for key, _ in pairs(dict) do
        table.insert(keys, key) 
    end
    return keys
end

function findLeftOnlyValues(ordering)
    leftOnlies = {}
    for i, order in ipairs(ordering) do
        leftOnlies[order[1]] = true
    end
    for i, order in ipairs(ordering) do
        -- print ("Processing : ", order[1], " ", order[2])
        -- print("Lefties ", table.concat(getDictKeys(leftOnlies), ", "))
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

function filterRules(rules, manual)
    filteredRules = {}

    for i, pair in ipairs(rules) do
        idx1 = findInList(manual, pair[1])
        idx2 = findInList(manual, pair[2])
        if idx1 and idx2 then
            table.insert(filteredRules, pair)
        end
    end
    return filteredRules
end


function createOrder(ordering) 
    resultOrder = {}
    allValues = {}

    for i, pair in ipairs(ordering) do
        allValues[pair[1]] = true
        allValues[pair[2]] = true
    end


    while #ordering > 0 do
        leftOnlies = findLeftOnlyValues(ordering)
        for i, value in ipairs(leftOnlies) do
            table.insert(resultOrder, value)
            removeLeftValue(ordering, value)
            allValues[value] = nil
        end
        -- print("New order ", table.concat(resultOrder, ", "))
    end

    count = 0
    for key, value in pairs(allValues) do
        count = count + 1
        -- print("Remaining unordered ", key)
        table.insert(resultOrder, key)
    end

    if count > 1 then
        print("Multiple values without clear order found, revise this algorithm")
    end


    return resultOrder    
end

function findInList(list, target)
    for i, value in ipairs(list) do
        if value == target then
            return i
        end
    end
    return nil
end

function checkManual(orderedList, manual) 

    currentIndex = 0
    for i, value in ipairs(manual) do
        idx = findInList(orderedList, value)
        -- print ("Value ", value, " has index ", idx, " current index is :", currentIndex)
        if idx then
            if idx < currentIndex then
                return false
            end
            currentIndex = idx
        end
    end


    return true
end

function getMiddle(list)
    length = #list
    middleValue = list[math.ceil(length/2)]
    -- print ("List: ", table.concat(list, ", "))
    -- print("Middle is ", length/2, " with value ", middleValue)
    return middleValue
end


ordering, manuals = parseInput("input")

resultA = 0
resultB = 0
for i, manual in ipairs(manuals) do
    filteredRules = filterRules(ordering, manual)
    orderedList = createOrder(filteredRules)
    -- print("New order ", table.concat(orderedList, ", "))
    
    valid = checkManual(orderedList, manual)
    print ("Manual", table.concat(manual, ", "), " is ")
    if valid then
        middleValue = getMiddle(manual)
        print ("correct: ", middleValue)
        resultA = resultA + middleValue
    else
        print "wrong"
        resultB = resultB + getMiddle(orderedList)

    end
end

print("Results: ", resultA, " ", resultB)
