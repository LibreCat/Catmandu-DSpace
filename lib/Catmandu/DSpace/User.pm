package Catmandu::DSpace::User;
use Catmandu::DSpace::Sane;
use Data::Util qw(:validate :check);
use Moo;

with qw(Catmandu::DSpace::UnSerializable);

has canLogIn => (is => 'ro',required => 1);
has email => (is => 'ro',required => 1);
has firstName => (is => 'ro',required => 1);
has fullName => (is => 'ro',required => 1);
has groups => (
  is => 'ro',
  isa => sub {
    my $array = $_[0];
    array_ref($array);
  },
  required => 1
);
has id => (is => 'ro',required => 1);
has language => (is => 'ro',required => 1);
has lastName => (is => 'ro',required => 1);
has netId => (is => 'ro');
has phone => (is => 'ro');
has requireCertificate => (is => 'ro');
has selfRegistered => (is => 'ro');

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
    #JSON::XS::Boolean => 1/0
    canLogIn => ($ref->{canLogIn} ? 1:0),
    email => $ref->{email},
    firstName => $ref->{firstName},
    lastName => $ref->{lastName},
    fullName => $ref->{fullName},
    groups => \@groups, 
    id => $ref->{id},
    language => $ref->{language},
    netId => $ref->{netId},
    phone => $ref->{phone},
    #JSON::XS::Boolean => 1/0
    requireCertificate => ($ref->{requireCertificate} ? 1:0),
    #JSON::XS::Boolean => 1/0
    selfRegistered => ($ref->{selfRegistered} ? 1:0)
  );
}

1;
