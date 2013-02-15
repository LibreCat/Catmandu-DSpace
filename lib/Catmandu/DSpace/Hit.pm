package Catmandu::DSpace::Object;
use Moo;
use Data::Util qw(:validate :check);

has id => (is => 'ro',required => 1);
has name => (is => 'ro',required => 1);
has resultHandles => (
  is => 'ro',
  isa => sub{
    my $array = shift;
    array_ref($array);
    for(@$array){
      (is_integer($_) && $_ >= 0) or die("resultHandle must natural number");
    }
  },
  required => 1
);
has resultIDs => (
  is => 'ro',
  isa => sub{
    my $array = shift;
    array_ref($array);
    for(@$array){
      (is_integer($_) && $_ >= 0) or die("resultID must natural number");
    }
  },
  required => 1
);
has resultsCount => (
  is => 'ro',
  isa => sub{
    my $num = shift;
    (is_integer($num) && $num >= 0) or die("resultsCount must natural number");
  },
  required => 1
);
1;
