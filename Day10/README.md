# Language choice

*Nim* - Seems interesting, I'm wondering how it will compare to zig. I hope it has Sets

# Approach to part one

Scan the input for starting points. Then run a depth first search from each point. Collect the co-ordinates reachable from each starting point in a set, to filter out multiple paths to the same peak. We could optimize this by storing the reachable peaks at each visited map location. But this seems like unnecessary work for now. Might become useful for part 2 though.


# Approach to part two
