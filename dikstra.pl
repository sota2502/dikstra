#!/usr/bin/env perl
use strict;
use warnings;


my @nodes = (
    {
        label      => 0,
        edges_to   => [qw/1 2 3/],
        edges_cost => [0, 5, 4, 2, 0, 0],
    },
    {
        label      => 1,
        edges_to   => [qw/0 2 5/],
        edges_cost => [5, 0, 2, 0, 0, 6],
    },
    {
        label      => 2,
        edges_to   => [qw/0 1 3 4/],
        edges_cost => [4, 2, 0, 3, 2, 0],
    },
    {
        label      => 3,
        edges_to   => [qw/0 2 4/],
        edges_cost => [2, 0, 3, 0, 6, 0],
    },
    {
        label      => 4,
        edges_to   => [qw/2 3 5/],
        edges_cost => [0, 0, 2, 6, 0, 4],
    },
    {
        label      => 5,
        edges_to   => [qw/1 4/],
        edges_cost => [0, 6, 0, 0, 4, 0],
    },
);


sub pop_min {
    my ($target, $leng) = @_;

    my $found;
    my $min = 1000;
    my @keys = keys %$target;
    foreach my $key (@keys) {
        my $node = $target->{$key};
        my $label = $node->{label};
        if ( $leng->{$label} < $min ) {
            $found = $node;
            $min   = $leng->{$label};
        }
    }

    return unless ( $found );

    delete $target->{$found->{label}};

    return $found;
}

my $start = 0;
my $goal  = 5;
my $large = 1000;

my %leng = map { $_->{label} => ( $_->{label} == 0 ? 0 : $large ) } @nodes;
my %prev;

my %target = map { $_->{label} => $_ } @nodes;

while ( keys %target ) {
    my $node = pop_min( \%target, \%leng );
    my $label = $node->{label};

    foreach my $to_label (@{$node->{edges_to}}) {
        my $to_node = $nodes[$to_label];
        my $to_cost = $node->{edges_cost}->[$to_label];

        if ( $leng{$to_label} > $leng{$label} + $to_cost ) {
            $leng{$to_label} = $leng{$label} + $to_cost;
            $prev{$to_label} = $label;
        }
    }
}


my @route;
my $position = $goal;
while ( $position != $start ) {
    unshift @route, $position;
    $position = $prev{$position};
}
unshift @route, $start;

printf "Cost:  %d\n", $leng{$goal};
printf "Route: %s\n", join(' -> ', @route);

