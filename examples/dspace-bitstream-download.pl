#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::DSpace::Sane;
use Catmandu::DSpace;
use File::Basename;
use Data::Util qw(:check);

my $dspace = Catmandu::DSpace->new(
  base_url => "http://localhost:8080/dspace-rest",
  username => 'nicolas.franck@ugent.be',
  password => "dspace"
);

my $file = shift;
is_string($file) && -d dirname($file) || die("cannot write to file");


open my $fh,">:raw",$file or die($!);

$dspace->bitstream_download(
  id => 100,
  callback => sub {
    print $fh $_[0];
  }
);

close $fh;
