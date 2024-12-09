# Language choice

*Julia* - No particular reason, except that it looks to have support for dynamic lists.

# Approach to part one

3 Parts to it: 

Convert the compressed disk map to a a list of blocks. This might get large, this could be where the problem with this puzzle lies and where I might need to get smarter. The naive approach I'll try first is just to iterate over the input and append to a result string.

Fragment the disk. Find the first occurence of an empty block and the last occurence of a filled block. If the empty block is before the filled one, switch them and continue.

Calculate the checksum. Iterate over every block and multiply by it's ID.


## Potential pitfalls

ID numbers are going to get greater than '9' so using a string does not seem like a good idea to keep track of things.

The uncompressed disk number could get massive. So far everything should be O(n), so as  long as there are no memory problems, it should be ok.

# Approach to part two

