# Language choice

It's a RegEx question! I know this! There is only one choice: *perl* (Also again let's get the hard ones out of the way first) 

# Approach to part one

Regex to match the numbers, extract submatches, multiply and add them up. Done

# Approach to part two

Keep the active state in a variable, search for multiply, `do's` and `dont's` at the same time. If a `don't` is found set inactive if a `do` is found set active. Only multiply and add if currently active.

