#!/usr/bin/env perl
use Test::Simple tests => 6;
use strict;
use warnings;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use Regex::Chain;
use Regex::Chain::Link;

my $chain_test = Regex::Chain->new;
ok( defined $chain_test, 'Regex::Chain->new is defined');
ok( $chain_test->isa('Regex::Chain'), 'isa Regex::Chain' );

my $link_test = Regex::Chain::Link->new;
ok( defined $link_test, 'Regex::Chain::Link->new is defined');
ok( $link_test->isa('Regex::Chain::Link'), 'isa Regex::Chain::Link' );

my $simple_replacement_string = "test-expression-match-and-Replace";
my $chain_simple_replacement = Regex::Chain->new;
$chain_simple_replacement->add({
    rule => '(\w+)-',
    replace => '$1 ',
    expression => 1,
});
ok( $chain_simple_replacement->run($simple_replacement_string) eq "test expression-match-and-Replace", 'Simple replacement' );

my $chain_simple_replacement = Regex::Chain->new;
$chain_simple_replacement->add({
    rule => '(\w+)-',
    replace => '$1 ',
    global => 1,
    expression => 1,
});
ok( $chain_simple_replacement->run($simple_replacement_string) eq "test test test test Replace", 'Simple replacement global' );
