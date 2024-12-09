
function readInput(filename)
    line = ""
    open(filename) do f
        line = readline(f)          
   end
   
    return line
end

function uncompressDiskMap(diskmap)
    emptyBlocks = false
    blockId = 0
    result = []
    for entry in diskmap
        value =  parse(Int,entry)
        println("C: $entry, I: $value")
        
        currentId = blockId
        if emptyBlocks
            currentId = -1
            blockId = blockId + 1
            emptyBlocks = false
        else
            emptyBlocks = true
        end
        for i in 1:value
            append!(result, currentId)
        end
    end
    return result
end

function getPreviousData(disk, startIndex)
    currentIndex = startIndex
    lastIndex = length(disk)
    while (disk[currentIndex] == -1 ) && (currentIndex > 0)
        currentIndex = currentIndex-1
    end    
    return currentIndex
end


function getNextEmpty(disk, startIndex)
    currentIndex = startIndex
    lastIndex = length(disk)
    while (disk[currentIndex] != -1 ) && (currentIndex <= lastIndex)
        currentIndex = currentIndex+1
    end    
    return currentIndex
end

function fragmentData(disk)
    emptyIndex = getNextEmpty(fullMap, 1)
    dataIndex = getPreviousData(fullMap, length(fullMap))

    while emptyIndex < dataIndex
        disk[emptyIndex] = disk[dataIndex]
        disk[dataIndex] = -1
        emptyIndex = getNextEmpty(fullMap, emptyIndex)
        dataIndex = getPreviousData(fullMap, dataIndex)
    end

end

function calculateChecksum(disk)
    index = 1
    result = 0

    for i in 1:length(disk)
        value = disk[i]
        if value != -1
            result = result + (value * (i-1))
        end
    end
    return result
end

compressedata = readInput("input")
# println("Data: $compressedata")
fullMap = uncompressDiskMap(compressedata)
# println("Full disk map: $fullMap")
fragmentData(fullMap)
# println("Full disk map: $fullMap")
checksum = calculateChecksum(fullMap)
println("Checksum: $checksum")

