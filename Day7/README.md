# Language choice

*Haskell* - This looks like something that will operate recursively on a list, a more functional programming language seems like a good choice, and there is a ton on of them that I haven't used yet. Time to start with one.

# Approach to part one

Parse the data, store it in a format of `expected result, list of numbers`, then recursively try to brute force all the potential operators. Should be complexity of `b * 2^n` where `b` is the number of lines and `n` is the number of numbers per line.

I need to reverse the list, because otherwise the numbers get combined back to front.

# Approach to part two

Straight forward just add one more operation in the recursive evaluation.