#!/usr/bin/env perl
use strict;
use warnings;


my @nodes = (
    {
        label      => 0,
        edges_to   => [qw/1 5/],
    },
    {
        label      => 1,
        edges_to   => [qw/0 2 6/],
    },
    {
        label      => 2,
        edges_to   => [qw/1 3/],
    },
    {
        label      => 3,
        edges_to   => [qw/2 8/],
    },
    {
        label      => 4,
        edges_to   => [qw/5 9/],
    },
    {
        label      => 5,
        edges_to   => [qw/0 4 6/],
    },
    {
        label      => 6,
        edges_to   => [qw/1 5 7/],
    },
    {
        label      => 7,
        edges_to   => [qw/2 6 8/],
    },
    {
        label      => 8,
        edges_to   => [qw/3 7 12/],
    },
    {
        label      => 9,
        edges_to   => [qw/6 10 11/],
    },
    {
        label      => 10,
        edges_to   => [qw/9 11/],
    },
    {
        label      => 11,
        edges_to   => [qw/10 12/],
    },
    {
        label      => 12,
        edges_to   => [qw/8 11/],
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

my $start     = 1;
my $goal      = 12;
my $large     = 1000;
my $edge_cost = 1;

my %leng = map { $_->{label} => ( $_->{label} == $start ? 0 : $large ) } @nodes;
my %prev;

my %target = map { $_->{label} => $_ } @nodes;

while ( keys %target ) {
    my $node = pop_min( \%target, \%leng );
    my $label = $node->{label};

    foreach my $to_label (@{$node->{edges_to}}) {
        my $to_node = $nodes[$to_label];

        if ( $leng{$to_label} > $leng{$label} + $edge_cost ) {
            $leng{$to_label} = $leng{$label} + $edge_cost;
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

