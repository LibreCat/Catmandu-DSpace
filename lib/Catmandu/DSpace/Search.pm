package Catmandu::DSpace::Search;
use Moo;
use Data::Util qw(:validate :check);

with qw(Catmandu::DSpace::UnSerializable);

has id => (is => 'ro',required => 1);
has name => (is => 'ro',required => 1);
has resultHandles => (
  is => 'ro',
  isa => sub{
    my $array = shift;
    array_ref($array);
    for(@$array){
      is_string($_) or die("resultHandle must be set");
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
has resultTypes => (
  is => 'ro',
  isa => sub{
    my $array = shift;
    array_ref($array);
    for(@$array){
      (is_integer($_) && $_ >= 0) or die("resultType must natural number");
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

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;
  array_ref($ref->{search});
  hash_ref($ref->{search}->[0]);
  
  $class->new(%{ $ref->{search}->[0] });
}
1;
