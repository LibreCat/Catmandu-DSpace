package DSpace::Group;
use DSpace::Sane;
use Data::Util qw(:validate :check);
use Moo;
use DSpace::Users;

with qw(DSpace::UnSerializable);

has groups => (
  is => 'ro',
  isa => sub {
    my $array = $_[0];
    array_ref($array);
  },
  required => 1
);
has users => (
  is => 'ro',
  isa => sub {
    my $array = $_[0];
    array_ref($array);
  },
  required => 1
);

has id => (is => 'ro',required => 1);
has name => (is => 'ro',required => 1);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;
  my @groups = ();
  for my $group(@{ $ref->{groups} // [] }){
    push @groups,$group->{id};
  }
  $class->new(
    name => $ref->{name},
    id => $ref->{id},
    groups => \@groups, 
    users => DSpace::Users->from_hash_ref($ref),
  );
}

1;
