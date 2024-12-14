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
    map.each do |row|
        print "|"
        row.each do |value|
            if value > 0
                print "#{value}"
            else
                print "."
            end
        end
        puts "|"
    end
  
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
time = 100;
bounds = {101,103}
robots = parse_robots(file_path)
new_positions = [] of Tuple(Int32, Int32)

robots.each do |robot|
    new_position = robot.move(time, bounds)
    # puts "Robot moved to Position=#{new_position}"
    new_positions << new_position
end

print_map(new_positions, bounds)
calculate_result(new_positions, bounds)