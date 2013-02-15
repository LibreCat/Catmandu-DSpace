package Catmandu::DSpace::MetadataField;
use Moo;

has id => (is => 'ro',required => 1);
has name => (is => 'ro',required => 1);

1;
