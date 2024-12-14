struct Robot
  property position : Tuple(Int32, Int32)
  property vector : Tuple(Int32, Int32)

  def initialize(position : Tuple(Int32, Int32), vector : Tuple(Int32, Int32))
    @position = position
    @vector = vector
  end

  def move(time : Int32, bounds : Tuple(Int32, Int32)) : Tuple(Int32, Int32)
    new_x = (@position[0] + @vector[0] * time) % bounds[0]
    new_y = (@position[1] + @vector[1] * time) % bounds[1]

    # # Ensure positive wrapping
    # new_x += bounds[0] if new_x < 0
    # new_y += bounds[1] if new_y < 0

    @position = {new_x, new_y}
  end
end

def parse_robots(file_path : String) : Array(Robot)
  robots = [] of Robot

  File.each_line(file_path) do |line|
    if match = /p=(\d+),(\d+)\s+v=(-?\d+),(-?\d+)/.match(line)
      position = {match[1].to_i, match[2].to_i}
      vector = {match[3].to_i, match[4].to_i}

      robots << Robot.new(position, vector)
    else
      puts "Invalid line format: #{line}"
    end
  end

  robots
end

def print_map(robots : Array(Tuple(Int32, Int32)), map_size : Tuple(Int32, Int32))
    map = Array.new(map_size[1]) { Array.new(map_size[0], 0) }
  
    robots.each do |robot|
        map[robot[1]][robot[0]] += 1
    end

    puts " "
    print "|"
    (0..map_size[0]-1).each do |i|
        print "-"
    end
    puts "|"

    map.each do |row|
        print "|"
        row.each do |value|
            if value > 0
                print "#{value}"
            else
                print " "
            end
        end
        puts "|"
    end

    print "|"
    (0..map_size[0]-1).each do |i|
        print "-"
    end
    puts "|"
end

def get_map_value(map : Array(Array(Int32)), map_size : Tuple(Int32, Int32), position : Tuple(Int32, Int32)) : Int32
    x = position[0] % map_size[0]
    y = position[1] % map_size[1]

    return map[y][x]
end

def calculate_distance_score(robots : Array(Tuple(Int32, Int32)), map_size : Tuple(Int32, Int32)) : Int32
    map = Array.new(map_size[1]) { Array.new(map_size[0], 0) }
    distance_score = 0
  
    robots.each do |robot|
        map[robot[1]][robot[0]] += 1
    end
    robots.each do |robot|
        x = robot[0]
        y = robot[1]
        robot_score = 0;
        robot_score += get_map_value(map, map_size, {x-1, y-1})
        robot_score += get_map_value(map, map_size, {x-1, y  })
        robot_score += get_map_value(map, map_size, {x-1, y+1})
        robot_score += get_map_value(map, map_size, {x  , y-1})
        robot_score += get_map_value(map, map_size, {x  , y  })
        robot_score += get_map_value(map, map_size, {x  , y+1})
        robot_score += get_map_value(map, map_size, {x+1, y-1})
        robot_score += get_map_value(map, map_size, {x+1, y  })
        robot_score += get_map_value(map, map_size, {x+1, y+1})
        if (robot_score > 0) && (robot_score <  4)
            distance_score += robot_score
        end
    end
  distance_score
end

def calculate_alone_score(robots : Array(Tuple(Int32, Int32)), map_size : Tuple(Int32, Int32)) : Int32
    map = Array.new(map_size[1]) { Array.new(map_size[0], 0) }
    distance_score = 0
  
    robots.each do |robot|
        map[robot[1]][robot[0]] += 1
    end
    robots.each do |robot|
        value = map[robot[1]][robot[0]]
        if value == 1
            distance_score += 1
        end
    end
  distance_score
end

def calculate_result(robots : Array(Tuple(Int32, Int32)), map_size : Tuple(Int32, Int32))
  center_x = map_size[0]/2 -0.5;
  center_y = map_size[1]/2 -0.5;

  counts = Array.new(4, 0)
  puts "Map gets divided at #{center_x} / #{center_y}"

  robots.each do |robot|
    x = robot[0]
    y = robot[1]
    x = x > center_x ? 1 : x < center_x ? 0 : -1
    y = y > center_y ? 1 : y < center_y ? 0 : -1
    if (x != -1) && (y != -1)
        counts[2*x + y] +=1
    end

  end
 result = counts[0] * counts[1] * counts[2] * counts[3]
 puts "Results are #{counts} = #{result}"
end

file_path = "input"
# time = 100;
bounds = {101,103}
robots = parse_robots(file_path)

(0..10000).each do |time|
    new_positions = [] of Tuple(Int32, Int32)
    robots.each do |robot|
        new_position = robot.move(time, bounds)
        new_positions << new_position
    end
    score = calculate_alone_score(new_positions, bounds)
    if score > 0

        puts "The time is now: #{time}, the score is #{score}"
        print_map(new_positions, bounds)
    end
end


# calculate_result(new_positions, bounds)