#!/usr/bin/env perl

use strict;
use warnings;

my $filename = $ARGV[0];
open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";
my $result = 0;
my $active = 1;

while (my $line = <$fh>) {
    chomp($line); # Remove trailing newline
    while ($line =~ /(mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\))/g) {
        my $match = $1;
        if (defined $2 && defined $3){
            if ( $active == 1 ) {
                $result += $2 * $3;
            }
        } elsif ($match =~ /^do\(\)$/) {
            $active = 1;
        } elsif ($match =~ /^don't\(\)$/) {
            $active = 0;
        } 
    }
}
print "Result is $result\n";

close($fh);