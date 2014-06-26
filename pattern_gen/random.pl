#!/usr/bin/perl

use strict;
use warnings;

sub pattern {
    if ( $_[0] < 2){
        $_[0] = 2;
    }

    my $str = "";

    foreach my $count (1 .. 16){ 
        my $random_number = int(rand($_[0]));
        $str = $str . $random_number;
    }
    return $str;
}

my $pattern_test = &pattern(5);

print $pattern_test;

