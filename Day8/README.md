# Language choice

*OCaml* -Not too sure about this one, but I did haskell yesterday, and this seems to be very close, so hopefully I will get some benefits from already being in the right mind set.

# Approach to part one

Parse the data and create listsfor each frequency, with the co-ordinates of each tower. Then parse the lists and calculate the antinodes for each frequency for each pair of towers. Do a final pass to clean up everything outside the bounds of the map or where two antinodes of the same frequency end up at the same co-ordinates.

# Approach to part two

Adjust the calculation of antinodes to calculate in either direction, until we get out of bounds of the map. Technically it shouldn't be too hard, but since the `get_antinodes` function if fairly deep inside the code, it will require a lot of adjustments of arguments.