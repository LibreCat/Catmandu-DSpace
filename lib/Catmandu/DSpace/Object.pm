package Catmandu::DSpace::Object;
use Moo;

has id => (is => 'ro',required => 1);
has handle => (is => 'ro',required => 1);
has name => (is => 'ro',required => 1);

1;
