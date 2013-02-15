#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::DSpace;
use open qw(:std :utf8);

my $dspace = Catmandu::DSpace->new(
  base_url => "http://localhost:8080/dspace-rest",
  username => 'nicolas.franck@ugent.be',
  password => "dspace"
);

$dspace->delete_item_metadata(
  id => 1,metadata_id => 144
);
