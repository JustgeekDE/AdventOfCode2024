# Language choice

*C++* - I wanted to save that for a latter time, but this problem screams out for a linked list, and those are fun to implement in C and C++, and I've already done C++;

# Approach to part one

Create a linked list from the input. Go through the list and apply the rules. Seems straightforward. Some pitfalls might be the splitting of the stones, using a linked list could be faster here than array operations. Though a linked list will lead to frequent cache misses.

# Approach to part two