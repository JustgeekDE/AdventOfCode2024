const std = @import("std");

const Direction = enum {NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST};

const PuzzleData = struct {
    contents: [][]u8, // Array of lines (each line is a slice of u8)
    max_x: usize,
    max_y: usize,

    pub fn free(self: *PuzzleData, allocator: std.mem.Allocator) void {
        for (self.contents) |line| {
            allocator.free(line);
        }
        allocator.free(self.contents);
    }
};

pub fn readInput(allocator: std.mem.Allocator, filePath: []const u8) !PuzzleData {
    var max_x: usize = 0;
    var max_y: usize = 0;

    var lines = std.ArrayList([]u8).init(allocator); 
    defer lines.deinit(); 

    var file = try std.fs.cwd().openFile(filePath, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    
    var buf: [1024]u8 = undefined; // Buffer to read into

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {

        max_x = if (line.len > max_x) line.len else max_x;
        max_y += 1;

        const copied_line = try allocator.dupe(u8, line); 
        try lines.append(copied_line);
    }

    return PuzzleData{
        .contents = try lines.toOwnedSlice(),
        .max_x = max_x,
        .max_y = max_y,
    };
}

pub fn findMas(puzzleData: *PuzzleData) u32 {
    const max_x = puzzleData.max_x;
    const max_y = puzzleData.max_y;
    var result:u32 = 0;

    var x:i32 = 0;
    var y:i32 = 0;

    while(y < max_y) {
        x = 0;
        while(x < max_x) {
            if (checkCharacter(x,y, 'A', puzzleData)){
                std.debug.print("Found an X: {d}/{d}\n", .{x, y});
                result += startMasSeach(x,y,puzzleData);
            }
            x += 1;
        }
        y += 1;
    }
    return result;
}

pub fn findXMas(puzzleData: *PuzzleData) u32 {
    const max_x = puzzleData.max_x;
    const max_y = puzzleData.max_y;
    var result:u32 = 0;

    var x:i32 = 0;
    var y:i32 = 0;

    while(y < max_y) {
        x = 0;
        while(x < max_x) {
            if (checkCharacter(x,y, 'X', puzzleData)){
                std.debug.print("Found an X: {d}/{d}\n", .{x, y});
                result += startSeach(x,y,puzzleData);
            }
            x += 1;
        }
        y += 1;
    }
    return result;
}

pub fn checkCharacter(x: i32, y: i32, char:u8, puzzleData: *PuzzleData) bool {
    if ((x < 0) or (x >=  puzzleData.max_x)) {
        return false;
    }
    if ((y < 0) or (y >= puzzleData.max_y)) {
        return false;
    }
    const safe_x:usize = @as(usize, @intCast(x)); 
    const safe_y:usize = @as(usize, @intCast(y)); 

    return (puzzleData.contents[safe_y][safe_x] == char);
}

pub fn startSeach(x: i32, y: i32, puzzleData: *PuzzleData) u32 {
    var result:u32 = 0;
    
    if (findString(x,y, Direction.NORTH, "XMAS", puzzleData)) {
        result +=1;
    }
    if (findString(x,y, Direction.NORTHEAST, "XMAS", puzzleData)) {
        result +=1;
    }
    if (findString(x,y, Direction.EAST, "XMAS", puzzleData)) {
        result +=1;
    }
    if (findString(x,y, Direction.SOUTHEAST, "XMAS", puzzleData)) {
        result +=1;
    }
    if (findString(x,y, Direction.SOUTH, "XMAS", puzzleData)) {
        result +=1;
    }
    if (findString(x,y, Direction.SOUTHWEST, "XMAS", puzzleData)) {
        result +=1;
    }
    if (findString(x,y, Direction.WEST, "XMAS", puzzleData)) {
        result +=1;
    }
    if (findString(x,y, Direction.NORTHWEST, "XMAS", puzzleData)) {
        result +=1;
    }

    return result;
}

pub fn startMasSeach(x: i32, y: i32, puzzleData: *PuzzleData) u32 {
    if (checkDiagonal(x,y, true, puzzleData) and checkDiagonal(x,y, false, puzzleData)) {
        return 1;
    }
    return 0;
}

pub fn checkDiagonal(x: i32, y: i32, backward: bool, puzzleData: *PuzzleData) bool {
    const modifier:i32 = if (backward) -1 else 1;
    if ( checkCharacter(x, y, 'A', puzzleData) == false) {
        return false;
    }

    if (checkCharacter(x-(modifier * 1), y-1  , 'M', puzzleData) and checkCharacter(x+(modifier * 1), y+1, 'S', puzzleData)) {
        return true;
    }
    if (checkCharacter(x+(modifier * 1), y+1, 'M', puzzleData) and checkCharacter(x-(modifier * 1), y-1, 'S', puzzleData)) {
        return true;
    }
    return false;
}



pub fn findString(x: i32, y: i32, direction: Direction, remaining_string: []const u8, puzzleData: *PuzzleData) bool {
    if (remaining_string.len < 1) {
        return true;
    }
    if (checkCharacter(x, y, remaining_string[0], puzzleData) == false) {
        return false;
    }
    var new_x = x;
    var new_y = y;
    if ((direction == Direction.NORTHEAST) or (direction == Direction.NORTH) or (direction == Direction.NORTHWEST)){
        new_y = y - 1;
    } 
    if ((direction == Direction.SOUTHEAST) or (direction == Direction.SOUTH) or (direction == Direction.SOUTHWEST)){
        new_y = y + 1;
    } 
    if ((direction == Direction.NORTHWEST) or (direction == Direction.WEST) or (direction == Direction.SOUTHWEST)){
        new_x = x - 1;
    } 
    if ((direction == Direction.NORTHEAST) or (direction == Direction.EAST) or (direction == Direction.SOUTHEAST)){
        new_x = x + 1;
    } 


    return findString(new_x, new_y, direction, remaining_string[1..], puzzleData);
}



pub fn main() !void {
    const allocator = std.heap.page_allocator; 

    const filePath = std.mem.span(std.os.argv[1]); 
    std.debug.print("Opening file: {s}\n", .{filePath});

    var puzzleData = try readInput(allocator, filePath); 
    defer puzzleData.free(allocator);  
    
    const result = findMas(&puzzleData);

    // Print the processed lines
    for (puzzleData.contents) |line| {
        std.debug.print("Line: {s}\n", .{line});
    }

    std.debug.print("Found {d} xmasses\n", .{result});
}
