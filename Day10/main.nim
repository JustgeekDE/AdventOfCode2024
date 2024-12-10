import std/sets
import std/strutils

type Location = object
  x: int
  y: int

type Map = object
  data: seq[seq[int]]
  max_x: int
  max_y: int

proc parseInput(filename: string) : Map =
    var data = newSeq[seq[int]]()
    var max_x = 0
    for line in lines filename:
        echo line
        var currentLine = newSeq[int]()
        for value in line:
            let height = int(value) - int('0')
            currentLine.add(height)

        if line.len() > max_x:
            max_x = line.len()
        data.add(currentLine)
    Map(data: data, max_x : max_x, max_y : data.len())


proc findStartPoints(map: Map) : HashSet[Location] = 
    var locations = initHashSet[Location]()
    for y, line in map.data:
        for x, value in line:
            if value == 0:
                var newLocation = Location(x:x, y:y)
                locations.incl(newLocation)

    return locations


proc getValue(x:int, y:int , map: Map) : int =
    if (x < 0) or (x >= map.max_x):
        return -1
    if (y < 0) or (y >= map.max_y):
        return -1
    return map.data[y][x]

proc getValue(location: Location, map: Map) : int =
    return getValue(location.x, location.y, map)


proc findPeaksForStart(start: Location, map : Map) : HashSet[Location]

proc checkSlope(start: Location, x_dif:int, y_dif:int, map: Map) : HashSet[Location] =
    let currentHeight = getValue(start, map)
    let nextHeight = getValue(start.x + x_dif, start.y + y_dif, map)

    if (nextHeight == currentHeight + 1):
        let newLocation = Location(x: start.x + x_dif, y:start.y + y_dif)
        return findPeaksForStart(newLocation, map)

    return initHashSet[Location]()



proc findPeaksForStart(start: Location, map : Map) : HashSet[Location] =
    var returnValue = initHashSet[Location]()
    if (start.x < 0) or (start.x >= map.max_x):
        return returnValue
    if (start.y < 0) or (start.y >= map.max_y):
        return returnValue

    let currentHeight = getValue(start, map)
    if  currentHeight == 9:
        returnValue.incl(Location(x: start.x, y: start.y))
        return returnValue
    echo "Checking location ", start

    returnValue.incl(checkSlope(start, 1, 0 , map))
    returnValue.incl(checkSlope(start, 0, 1 , map))
    returnValue.incl(checkSlope(start, -1, 0, map))
    returnValue.incl(checkSlope(start, 0, -1, map))

    return returnValue

proc findScores(map:Map): int =
    var score = 0
    let startLocations = findStartPoints(map)
    for location in startLocations:
        let peaks = findPeaksForStart(location, map)
        # echo "Start: ", location, " has ", peaks.card(), " peaks reachable"
        score = score + peaks.card() 


    return score


var map = parseInput("input")
echo "Score is ",findScores(map)