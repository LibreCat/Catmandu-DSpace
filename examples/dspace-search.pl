#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::DSpace;
use Catmandu::DSpace::Sane;

my $dspace = Catmandu::DSpace->new(
  base_url => "http://localhost:8080/dspace-rest",
  username => 'nicolas.franck@ugent.be',
  password => "dspace"
);

my $query = shift;
my $search = $dspace->search(query => $query);
say "id: ".$search->id;
say "name: ".$search->name;
say "resultHandles:";
say "\t$_" for(@{ $search->resultHandles() });
say "resultIDs:";
say "\t$_" for(@{ $search->resultIDs() });
say "resultTypes:";
say "\t$_" for(@{ $search->resultTypes() });

say "resultsCount: ".$search->resultsCount;
