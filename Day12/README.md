# Language choice

*Raku* it's the successor to Perl, so I'm hoping for Perl with better data structures and stdlib.

# Approach to part one

Go over the input co-ordinate by co-ordinate. For each place, look up if we allready have a region associated with it. If not, create a new region and add search the map for all areas with the same plant that can be reached from our current tile.

To calculate the area later, we only need to check how many tiles are in each region. To calculate the fence length we iterate over all the tiles and check how many adjecent tiles do not contain the same Plant.


# Approach to part two

