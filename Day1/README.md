# Language choice

*Bash* let's get the frustrating things out of the way first.


# Approach to part one

Create two arrays, sort them, iterate over both at the same time, substract one from the other and sum up the absolutes of the differences. Mostly complicated by the fact that Bash has crap support for different return types.


# Approach to part two

Take the two list, iterate over list a, for each entry search how often it appears in list b. Could be majorly optimized by using pointers, sorted lists and stopping ones you find a value that's bigger than the needle. But this is bash.
