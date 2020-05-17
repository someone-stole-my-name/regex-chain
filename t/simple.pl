#!/usr/bin/env perl
use Test::Simple tests => 8;
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

my $simple_replacement_string = "test-simple-match-and-Replace";
my $chain_simple_replacement = Regex::Chain->new;
$chain_simple_replacement->add({
    rule => "-",
    replace => " "
});
ok( $chain_simple_replacement->run($simple_replacement_string) eq "test simple-match-and-Replace", 'Simple replacement' );

my $chain_simple_replacement = Regex::Chain->new;
$chain_simple_replacement->add({
    rule => "-",
    replace => " ",
    global => 1
});
ok( $chain_simple_replacement->run($simple_replacement_string) eq "test simple match and Replace", 'Simple replacement global' );

my $chain_simple_replacement = Regex::Chain->new;
$chain_simple_replacement->add({
    rule => "replace",
    replace => ""
});
ok( $chain_simple_replacement->run($simple_replacement_string) eq "test-simple-match-and-Replace", 'Simple replacement without ignorecase' );

my $chain_simple_replacement = Regex::Chain->new;
$chain_simple_replacement->add({
    rule => "replace",
    replace => "",
    ignorecase => 1
});
ok( $chain_simple_replacement->run($simple_replacement_string) eq "test-simple-match-and-", 'Simple replacement with ignorecase' );
