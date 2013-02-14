package DSpace::Metadata;
use Moo;

with qw(DSpace::UnSerializable);

has id => (is => 'ro',required => 1);
has element => (is => 'ro',required => 1);
has qualifier => (is => 'ro');
has schema => (is => 'ro',required => 1);
has value => (is => 'ro',required => 1);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;
  my %args;
  $args{$_} = $ref->{$_} for(qw(id element qualifier schema value));
  $class->new(%args);
}
1;
