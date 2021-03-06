#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::DSpace;
use open qw(:std :utf8);
use Data::Dumper;

my $dspace = Catmandu::DSpace->new(base_url => "http://localhost:8080/dspace-rest");

my $collections = $dspace->collections;
print Dumper($collections);
my $collection = $dspace->collection(id => 1);
print Dumper($collection);
