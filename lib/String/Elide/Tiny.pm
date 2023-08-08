package String::Elide::Tiny;

# be tiny
#IFUNBUILT
use strict;
use warnings;
#END IFUNBUILT

# AUTHORITY
# DATE
# DIST
# VERSION

sub import {
    my $pkg = shift;
    my $caller = caller;
#IFUNBUILT
no strict 'refs';
#END IFUNBUILT
    for my $sym (@_) {
        if ($sym eq 'elide') { *{"$caller\::$sym"} = \&{$sym} }
        else { die "$sym is not exported!" }
    }
}

sub elide {
    my ($str, $max_len, $opts) = @_;

    die "Please specify str" unless defined $str;
    die "Please specify max_len" unless defined $max_len;
    $opts ||= {};

    my $str_len = length $str;

    my $marker = defined $opts->{marker} ? $opts->{marker} : "...";
    my $marker_len = length $marker;
    return substr($marker, 0, $max_len) if $max_len < $marker_len;

    return $str if $str_len <= $max_len;

    my $truncate = $opts->{truncate} || 'right';
    if ($truncate eq 'left') {
        return $marker . substr($str, $str_len - $max_len + $marker_len);
    } elsif ($truncate eq 'middle') {
        my $left  = substr($str, 0,
                           ($max_len - $marker_len)/2);
        my $right = substr($str,
                           $str_len - ($max_len - $marker_len - length($left)));
        return $left . $marker . $right;
    } elsif ($truncate eq 'ends') {
        if ($max_len <= 2 * $marker_len) {
            return substr($marker . $marker, 0, $max_len);
        }
        return $marker . substr($str, ($str_len - $max_len)/2 + $marker_len,
                                $max_len - 2*$marker_len) . $marker;
    } else { # right
        return substr($str, 0, $max_len - $marker_len) . $marker;
    }
}

1;
# ABSTRACT: A very simple text truncating function, elide()

=head1 SYNOPSIS

 use String::Elide::Tiny qw(elide);

 # ruler:                                      0----5---10---15---20
 my $text =                                   "this is your brain";
 elide($text, 16);                       # -> "this is your ..."
 elide($text, 14);                       # -> "this is yo ..."

 # marker option:
 elide($text, 14, {marker=>"xxx"});      # -> "this is youxxx"

 # truncate option:
 elide($text, 14, {truncate=>"left"});   # -> "... your brain"
 elide($text, 14, {truncate=>"middle"}); # -> "this ... brain"
 elide($text, 14, {truncate=>"ends"});   # -> "...is your ..."


=head1 DESCRIPTION

This module offers L</elide>() function that is very simple; it's not
word-aware. It has options to choose marker or to select side(s) to truncate.


=head1 FUNCTIONS

=head2 elide

Usage:

 my $truncated = elide($str, $max_len [ , \%opts ])

Elide a string with " ..." if length exceeds C<$max_len>.

Known options:

=over

=item * truncate

String, either C<right>, C<left>, C<middle>, C<ends>.

=item * marker

String. Default: "...".

=back


=head1 SEE ALSO

L<Text::Elide> is also quite simple and elides at word boundaries, but it's not
tiny enough.

L<Text::Truncate> is tiny enough, but does not support truncating at the
left/both ends.

L<String::Elide::Parts> can elide at different points of the string.

L<String::Truncate> has similar interface like String::Elide::Parts and has some
options. But it's not tiny: it has a couple of non-core dependencies.

L<String::Elide::Lines> is based on this module but works on a line-basis.

=cut
