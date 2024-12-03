#!/usr/bin/env perl

use strict;
use warnings;

my $filename = $ARGV[0];
open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";
my $result = 0;

while (my $line = <$fh>) {
    chomp($line); # Remove trailing newline
    while ($line =~ /mul\((\d{1,3}),(\d{1,3})\)/g){
            print "Found a pair: $1, $2\n"; 
            $result += $1 * $2;
    }
}
print "Result is $result\n";

close($fh);