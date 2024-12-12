
class Region {
    has $.plant;
    has @.coordinates;

    method contains($x,$y) {
        ($x, $y) ~~ any @.coordinates;
    }

    method add($x,$y) {
        @.coordinates.push(($x, $y));
    }

    method area() {
        return self.coordinates.elems;
    }
    method circumference($map) {
        my $circumference = 0;
        for @.coordinates.kv -> $index, @tile {
            my $x = @tile[0];
            my $y = @tile[1];

            if ($map.getPlant($x-1,$y) ne self.plant) {
                $circumference = $circumference + 1;
            }
            if ($map.getPlant($x,$y-1) ne self.plant) {
                $circumference = $circumference + 1;
            }
            if ($map.getPlant($x+1,$y) ne self.plant) {
                $circumference = $circumference + 1;
            }
            if ($map.getPlant($x,$y+1) ne self.plant) {
                $circumference = $circumference + 1;
            }
        }
        return $circumference;
    }

    method sides($map) {
        my $sides = 0;
        for @.coordinates.kv -> $index, @tile {
            my $x = @tile[0];
            my $y = @tile[1];
            $sides += $map.countCorners($x, $y);

        }
        return $sides;
    }

}

class Map {

    has $.max_x;
    has $.max_y;
    has @.data;
    has @.regions = [];

    method print {
        my $totalPrice = 0;
        my $nrRegions = self.regions.elems;
        say "Map of size $.max_x / $.max_y";
        say "Got $nrRegions regions: ";
        for @.regions.kv -> $index, $region {
            my $plant = $region.plant;
            my $area = $region.area();
            my $circ = $region.circumference(self);
            my $sides = $region.sides(self);
            say "  Region $index has plant $plant with an area of $area, a fence length of $circ and $sides sides.";
            $totalPrice += ($area * $sides);
        }
        say "For a total price of $totalPrice";
    }

    method getRegion($x, $y) {
        for @.regions.kv -> $index, $region {
            if $region.contains($x, $y) {
                return $region;
            }
        }
        return Nil;
    }

    method createRegions {
        for ^$.max_y -> $y {
            for ^$.max_x -> $x {
                my $plantType = self.getPlant($x, $y);
                if (self.getRegion($x, $y) === Nil) {
                    say "Creating new region for $plantType at ($x / $y)";
                    my $region = Region.new(plant => $plantType, coordinates => []);
                    self.regions.push($region);
                    self.createRegion($x, $y, $region);
                } 
            }
        }
    }

    method createRegion($x, $y, $region) {
        if $region.contains($x, $y) {
            return;
        }
        if self.getPlant($x, $y) ne $region.plant {
            return;
        }
        $region.add($x, $y);
        self.createRegion($x-1, $y, $region);
        self.createRegion($x, $y-1, $region);
        self.createRegion($x+1, $y, $region);
        self.createRegion($x, $y+1, $region);
    }

    method getPlant($x, $y) {
        if ($x >= $.max_x) || ($x < 0) {
            return " ";
        }
        if ($y >= $.max_y) || ($y < 0) {
            return " ";
        }
        return @.data[$y].substr($x,1);
    }

    method countCorners($x,$y) {
        my $plant = self.getPlant($x, $y);
        my $neighbourCount = 0;
        my $north = self.getPlant($x, $y-1) eq $plant;
        my $south = self.getPlant($x, $y+1) eq $plant;
        my $east = self.getPlant($x+1, $y) eq $plant;
        my $west = self.getPlant($x-1, $y) eq $plant;

        if $north {$neighbourCount++};
        if $south {$neighbourCount++};
        if $east {$neighbourCount++};
        if $west {$neighbourCount++};

        if ($neighbourCount == 4) {
            return self.countAcuteCorners($x, $y);
        }
        if ($neighbourCount == 3) {
            return self.countAcuteCorners($x, $y);
        }
        if ($neighbourCount == 2) {
            if ($north != $south) {
                return 1 + self.countAcuteCorners($x, $y);
            }
            return 0;
        }
        if ($neighbourCount == 1) {
            return 2;
        }
        return 4;
    }

    method countAcuteCorners($x, $y) {
        my $result = 0;
        $result += self.isAcuteCorner($x,$y, -1, -1);
        $result += self.isAcuteCorner($x,$y, 1, -1);
        $result += self.isAcuteCorner($x,$y, -1, 1);
        $result += self.isAcuteCorner($x,$y, 1, 1);
        return $result;
    }

    method isAcuteCorner($x, $y, $dx, $dy) {
        my $plant = self.getPlant($x, $y);
        my $corner = self.getPlant($x + $dx, $y+$dy) ne $plant;
        my $xDir = self.getPlant($x+$dx, $y) eq $plant;
        my $yDir = self.getPlant($x, $y+$dy) eq $plant;
        
        if ($xDir && $yDir && $corner) {
            return 1;
        }
        return 0;
    }
}

sub parseInput($filename) {
    my $max_x = 0;
    my $max_y = 0;
    my @lines = [];
    for $filename.IO.lines -> $line {
        @lines.push($line);
        if ($line.chars > $max_x) {
            $max_x = $line.chars;
        }
        $max_y = $max_y + 1;
        # Do something with $line
    }
    Map.new(max_x=> $max_x, max_y=> $max_y, data=>@lines);
}

sub MAIN($filename){
    my $map = parseInput($filename);
    $map.print();
    $map.createRegions();
    $map.print();
}
