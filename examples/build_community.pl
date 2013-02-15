#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::DSpace::Community;
use open qw(:std :utf8);
use Data::Dumper;

local($/) = undef;
my $xml = <STDIN>;
my $community = Catmandu::DSpace::Community->from_xml($xml);
print Dumper($community);
