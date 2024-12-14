# Language choice

*Crystal* never heard of it before, but it sounds easy to use.

# Approach to part one

Rather than simulating the robots for each step, it should be straightforward to calculate their position by multiplying the vector with the time and then calculating it modulo the space. Hopefully this sets me on the right path for part two. If instead there is something about them moving eratically, at least that code should still be useable for something.

# Approach to part two

I have no idea what a christmas tree should look like, so let's start by looking at how the robots look in general. Looking through the first 200 iterations manually, there doesn't seem to be much of a tree in there. But there are relatively few robots on a large map. My assumption is that a christmas tree will have most robots line up next to each other, so we could calculate the distance for each robot to the next and see if that helps.
In the end the correct score was to check if each robot was on it's own tile.