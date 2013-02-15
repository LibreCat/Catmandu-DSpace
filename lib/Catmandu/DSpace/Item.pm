package Catmandu::DSpace::Item;
use Catmandu::DSpace::Sane;
use Data::Util qw(:validate :check);
use Moo;
use Catmandu::DSpace::User;
use Catmandu::DSpace::Metadata;

extends qw(Catmandu::DSpace::Object);
with qw(Catmandu::DSpace::UnSerializable);

has collection => (is => 'ro',required => 1);
has isArchived => (is => 'ro',required => 1);
has isWithdrawn => (is => 'ro',required => 1);
has lastModified => (
  is => 'ro',
  isa => sub { 
    my $num = shift;
    (is_integer($num) && $num >= 0) or die("lastModified must be natural number");
  },
  required => 1
);
has metadata => (
  is => 'ro',
  isa => sub { 
    array_ref($_[0]); 
    for(@{ $_[0] }){
      instance($_,"Catmandu::DSpace::Metadata");
    }
  },
  lazy => 1,
  default => sub { []; }
);
has submitter => (
  is => 'ro',
  isa => sub { instance($_[0],"Catmandu::DSpace::User"); },
  required => 1
);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;
  my @metadata = ();
  for my $m(@{ $ref->{metadata} // [] }){
    push @metadata,Catmandu::DSpace::Metadata->from_hash_ref($m);
  }
  $class->new(
    id => $ref->{id},
    handle => $ref->{handle},
    name => $ref->{name},
    isArchived => ($ref->{isArchived} ? 1:0),
    isWithdrawn => ($ref->{isWithdrawn} ? 1:0), 
    lastModified => $ref->{lastModified},
    metadata => \@metadata,
    collection => $ref->{collection}->{id},
    submitter => Catmandu::DSpace::User->from_hash_ref($ref->{submitter})
  );
}

1;
