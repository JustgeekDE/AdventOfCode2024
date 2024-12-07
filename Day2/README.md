# Language choice

*C* again let's get the annoying parts out of the way early. But considering that this looks like very structured data, and can probably be done without much data manipulation, this looks like a good choice.


# Approach to part one

Straight forward, parse the data, iterate over each line pairwaise. For each pair check if the value is ascending or descending, if the direction matches the previous direction and if the difference is less than 4. 


# Approach to part two

There might be some solution with storing the differences and checking if we can reduce the list by adding an unsafe value with the previous or next one. But this is C - Not very sophisticated in its tools but very fast. So we are gonna brute force it. For every line that is deemed unsafe, iterate over each value and create a new list that skips that particular value.
