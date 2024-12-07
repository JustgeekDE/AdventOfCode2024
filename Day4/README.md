# Language choice

*Zig* I have no idea what this language is, but if I wan't to get to 24 different ones, I have to get some weird ones. It looks very C like and this looks like a nice 2 dimensional array, so this should work.

# Approach to part one

Go over all the data until I find an X, then from there start a search in all 8 directions. Each search get's a position, direction and a remaining string to find ("XMAS", "MAS", "AS", "S"). If the position is out of bounds, or the character at that position doesn't match the character at the beginning of the string, return false. Else advance the position, remove the first character of the search string and continue. 

# Approach to part two

Actually this might be easier. Seach for 'A's. If found check that the diagonal is either "MAS" or "SAM", multiply the co-ordinate offsets by -1 to check in the other diagonal direction.



