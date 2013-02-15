#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::DSpace;
use open qw(:std :utf8);
use Data::Dumper;

my $dspace = Catmandu::DSpace->new(
  base_url => "http://localhost:8080/dspace-rest",
  username => 'nicolas.franck@ugent.be',
  password => "dspace"
);

for(1 .. 4){
  my $collection_id = $dspace->add_collection(
    collection => {
      name => "This is another cool collection of community 1, nr. $_!",
      communityId => "1"
    }
  );
}
