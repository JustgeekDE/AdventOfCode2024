# Language choice

*Lua* a fun language. After zig I want some fun. Also Lua might still be a bit limiting when it comes to more complex data structures, so better to use it early.

# Approach to part one

Take all the rules and an empty result list. Look for the number that only appears on the left. This number has no other page that needs to appear in front of it. Take that number put it at the end of our result list, and remove all the rules that had this number on the left. Repeat until rules are empty. This should give us a definite ordering of all the pages.

Then we can check the index for each of the  pages to produce and check that each one has a higher index in the ordering list then the previous one.

Of course the infite loop in the ordering bit me in the ass. Easy solution: Do the same thing, but rather than creating one global ordering, do it only for the pages we actually care about. Make a copy of the rules and remove every rule where at least one page number does not appear in the "pages to produce". Proceed as planned.


# Approach to part two

You know what, having the list of rules sorted and limited to only the relevant pages, already produces the only correct ordering of pages. I wouldn't have needed to do the whole comparing indices. I'm an idiot.

