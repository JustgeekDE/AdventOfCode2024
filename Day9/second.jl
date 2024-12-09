
function readInput(filename)
    line = ""
    open(filename) do f
        line = readline(f)          
   end
   
    return line
end

function splitInput(diskmap)
    emptyBlocks = false
    blockId = 0
    result = []
    for entry in diskmap
        value =  parse(Int,entry)
        
        currentId = blockId
        if emptyBlocks
            currentId = -1
            blockId = blockId + 1
            emptyBlocks = false
        else
            emptyBlocks = true
        end
        push!(result, (currentId, value))
    end
    return result
end


function findEmptySpace(disk, size)
    for i in eachindex(disk)
        currentBlock = disk[i]

        currentID = currentBlock[1]
        currentSize = currentBlock[2]
        if (currentID == -1) && ( currentSize >= size)
            return i
        end
    end
    return -1
end


function moveBlock(disk, sourceIndex, targetIndex)
    result = []
    for i in eachindex(disk)
        currentBlock = disk[i]
        if i == targetIndex
            sourceBlock = disk[sourceIndex]
            push!(result, sourceBlock)
            if sourceBlock[2] < currentBlock[2]
                push!(result, (-1, currentBlock[2] - sourceBlock[2]))
            end
            continue
        end
        if i == sourceIndex
            push!(result, (-1, currentBlock[2]))
            continue
        end
        push!(result, currentBlock)
    end
    return result
end


function defragSingleRun(diskMap, position)

    currentBlock = diskMap[position]
    currentId = currentBlock[1]
    size = currentBlock[2]
    if currentId != -1
        newPosition = findEmptySpace(diskMap, size)
        if (newPosition != -1) && (newPosition < position)
            println("Found new position for $currentId: $newPosition")
            diskMap = moveBlock(diskMap, position, newPosition)
            # diskMap = mergeEmptyBlocks(diskMap)
            # diskMap = mergeEmptyBlocks(diskMap)
        end
    end
    return diskMap
end

function findIndexForId(disk, ID)
    for i in eachindex(disk)
        if disk[i][1] == ID
            return i
        end        
    end
    return -1
end

function defrag(disk) 
    currentID = -1
    currentID = disk[end][1]
    if currentID == -1
        currentID = disk[end-1][1]
    end
    while currentID >= 0
        index = findIndexForId(disk, currentID)
        disk = defragSingleRun(disk, index)
        printCompressedMap(disk)
        currentID = currentID -1
    end
    return disk
end

function mergeEmptyBlocks(disk)
    result = []
    i = 1
    merged = false
    while i < length(disk) +1
        currentBlock = disk[i]
        currentId = currentBlock[1]
        currentSize = currentBlock[2]

        if (currentId == -1) && i < length(disk)
            nextBlock = disk[i+1]
            nextId = nextBlock[1]
            nextSize = nextBlock[2]
            if nextId == -1
                newSize = currentSize + nextSize
                currentBlock= (-1, newSize)
                i += 1
            end
        end
        i += 1
        push!(result, currentBlock)
    end
    return result
end


function uncompressDiskMap(disk)
    result = []
    for i in eachindex(disk)
        id = disk[i][1]
        size = disk[i][2]
        for i in 1:size
            append!(result, id)
        end
    end
    return result
end


function printCompressedMap(disk)
    # uncompressed = uncompressDiskMap(disk)
    # println("Disk: $uncompressed")

end

function calculateChecksum(disk)
    index = 1
    result = 0

    for i in eachindex(disk)
        value = disk[i]
        if value != -1
            result = result + (value * (i-1))
        end
    end
    return result
end

compressedata = readInput("input")
println("Data: $compressedata")
structuredData = splitInput(compressedata)
printCompressedMap(structuredData)
defraggedDisk = defrag(structuredData)
# fragmentData(fullMap)
# # println("Full disk map: $fullMap")
fullMap = uncompressDiskMap(defraggedDisk)
checksum = calculateChecksum(fullMap)
println("Checksum: $checksum")

