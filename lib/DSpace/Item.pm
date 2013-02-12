package DSpace::Item;
use DSpace::Sane;
use Data::Util qw(:validate :check);
use Moo;
use DSpace::User;

extends qw(DSpace::Object);
with qw(DSpace::JSON DSpace::HashRef);

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
      hash_ref($_);
      for my $key(qw(element id qualifier schema value)){
        if(!exists($_->{$key})){
          die("metadata element has no key '$key'");
        }
      }
    }
  },
  lazy => 1,
  default => sub { []; }
);
has submitter => (
  is => 'ro',
  isa => sub { instance($_[0],"DSpace::User"); },
  required => 1
);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;
  $class->new(
    id => $ref->{id},
    handle => $ref->{handle},
    name => $ref->{name},
    isArchived => ($ref->{isArchived} ? 1:0),
    isWithdrawn => ($ref->{isWithdrawn} ? 1:0), 
    lastModified => $ref->{lastModified},
    metadata => $ref->{metadata},
    collection => $ref->{collection}->{id},
    submitter => DSpace::User->from_hash_ref($ref->{submitter})
  );
}

1;
