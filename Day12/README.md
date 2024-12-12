# Language choice

*Raku* it's the successor to Perl, so I'm hoping for Perl with better data structures and stdlib.

# Approach to part one

Go over the input co-ordinate by co-ordinate. For each place, look up if we allready have a region associated with it. If not, create a new region and add search the map for all areas with the same plant that can be reached from our current tile.

To calculate the area later, we only need to check how many tiles are in each region. To calculate the fence length we iterate over all the tiles and check how many adjecent tiles do not contain the same Plant.


# Approach to part two

The number of sides is equal to the number of corners a shape has. The obtuse corners should be easy to find, just by checking the four directly adjecent tiles. The acute corners are a bit harder to find, for those we need to check the diagonals as well. But it should be possible to reduce the number of checks by a factor of 4, by using the rotational symetry.
