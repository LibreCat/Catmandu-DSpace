#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use DSpace;
use open qw(:std :utf8);
use Data::Dumper;

my $dspace = DSpace->new(
  base_url => "http://localhost:8080/dspace-rest",
  username => 'nicolas.franck@ugent.be',
  password => "dspace"
);

my $bundles = $dspace->item_bundles(id => 1);
print Dumper($bundles);
