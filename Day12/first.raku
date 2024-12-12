
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
            say "  Region $index has plant $plant with an area of $area and fence length of $circ";
            $totalPrice += ($area * $circ);
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
