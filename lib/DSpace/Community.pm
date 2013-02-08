package DSpace::Community;
use DSpace::Sane;
use Data::Util qw(:validate :check);
use Moo;

extends qw(DSpace::Object);
with qw(DSpace::JSON DSpace::HashRef);

has shortDescription => (is => 'ro');
has introductoryText => (is => 'ro');
has sidebarText => (is => 'ro');
has copyrightText => (is => 'ro');
has collections => (
  is => 'ro',
  isa => sub { 
    array_ref($_[0]); 
  },
  lazy => 1,
  default => sub { []; }
);
has parentCommunity => ( is => 'ro' );
has subCommunities => (
  is => 'ro',
  isa => sub {
    array_ref($_[0]); 
  },
  lazy => 1,
  default => sub { []; }
);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;
  my @subCommunities = ();
  for my $subc(@{ $ref->{subCommunities} || [] }){
    #enkel id: return is array van id's
    #ook andere attributen: return is array van communities
    my $com = scalar(keys %$subc) > 1 ? $class->from_hash_ref($subc) : $subc->{id};
    push @subCommunities,$com;
  }
  my @collections = ();
  for my $c(@{ $ref->{collections} || [] }){
    push @collections,$c->{id};
  }
  $class->new(
    id => $ref->{id},
    handle => $ref->{handle},
    name => $ref->{name},
    shortDescription => $ref->{shortDescription},
    introductoryText => $ref->{introductoryText}, 
    sidebarText => $ref->{sidebarText},
    copyrightText => $ref->{copyrightText},
    collections => \@collections,
    parentCommunity => $ref->{parentCommunity},
    subCommunities => \@subCommunities
  );
}

1;
