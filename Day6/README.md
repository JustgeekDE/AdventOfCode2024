# Language choice

*PHP* I haven't used this since my days writing facebook apps. But from what I remember it's all about arrays. Which is good, since this looks like there will be a lot of array interactions here.

# Approach to part one

This seems pretty straight forward. Walk along the map, look ahead to see if the next tile would be an obstacle or out of bounds. If it's an obstacle turn 90 degrees, if it's out of bounds end the loop. Having an enum for the direction, with a custom value for how this modifies the x and y position would be neat, but I don't know how to do this in PHP.

To only count the new locations, I can keep track of the visited locations like in the example, by modifying the map with Xs for already visited co-ordinates.

# Approach to part two

In theory this should be easy. Two problems: Where to place the obstacles and how to detect an endless loop.

To detect the endless loop I can create a second map, this time not only tracking whether I visited, but also which direction I was going. If I end up in the same place facing the same direction, I'm in a loop.

To decide where to place the obstacles, I can just walk along the path and with each step check what would happen if I placed an obstacle in front of me. There are probably smarter ways to do this, but I'm not doing this for elegance. I'm doing this to use as many weird languages as possible.

What got me this time is that I should only try to place an obstacle the first time I visit a location. If I cross over some co-ordinates again and place an obstacle there, I would have change direction earlier already.

