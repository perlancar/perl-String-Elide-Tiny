#!perl

use strict;
use warnings;
use Test::More 0.98;

use String::Elide::Tiny qw(elide);

is(elide("1234567890", 12), "1234567890");
is(elide("1234567890", 10), "1234567890");
is(elide("1234567890", 6), "12 ...");

done_testing;
