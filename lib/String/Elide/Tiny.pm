package String::Elide::Tiny;

# DATE
# VERSION

# be tiny
#use strict 'subs', 'vars';
#use warnings;

sub import {
    my $pkg = shift;
    my $caller = caller;
    for my $sym (@_) {
        if ($sym eq 'elide') { *{"$caller\::$sym"} = \&{$sym} }
        else { die "$sym is not exported!" }
    }
}

sub elide {
    my ($str, $max_len) = @_;

    # XXX check that max_len >= length " ..."
    my $len = length $str;
    return $str if $len <= $max_len;
    substr($str, 0, $max_len-4) . " ...";
}

1;
# ABSTRACT: A very simple text truncating function, elide()

=head1 SYNOPSIS

 use String::Elide::Tiny qw(elide);

 #                                             0----5---10---15---20
 my $text =                                   "this is your brain";
 elide($text, 16);                       # -> "this is your ..."
 elide($text, 14);                       # -> "this is yo ..."


=head1 DESCRIPTION

This module offers L</elide>() function that is very simple; it's not
word-aware.


=head1 FUNCTIONS

=head2 elide

Usage:

 my $truncated = elide($str, $max_len)

Elide a string with " ..." if length exceeds C<$max_len>.


=head1 SEE ALSO

L<Text::Elide> is also quite simple and elides at word boundaries, but it's not
tiny enough.

L<String::Elide::Parts> can elide at different points of the string.

L<String::Truncate> has similar interface like String::Elide::Parts and has some
options.

L<String::Elide::Lines> is based on this module but works on a line-basis.

=cut
