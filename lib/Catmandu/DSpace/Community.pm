package Catmandu::DSpace::Community;
use Catmandu::DSpace::Sane;
use Data::Util qw(:validate :check);
use Moo;
use Catmandu::DSpace::Collection;

extends qw(Catmandu::DSpace::Object);
with qw(Catmandu::DSpace::UnSerializable);

has shortDescription => (is => 'ro');
has introductoryText => (is => 'ro');
has sidebarText => (is => 'ro');
has copyrightText => (is => 'ro');
has collections => (
  is => 'ro',
  isa => sub { 
    array_ref($_[0]); 
    for(@{ $_[0] }){
      instance($_,"Catmandu::DSpace::Collection");
    }
  },
  lazy => 1,
  default => sub { []; }
);
has parentCommunity => ( 
  is => 'ro',
  isa => sub {
    my $ref = $_[0];
    #moet ofwel undefined zijn, ofwel Catmandu::DSpace::Community
    defined($ref) && instance($ref,"Catmandu::DSpace::Community");
  }
);
has subCommunities => (
  is => 'ro',
  isa => sub {
    array_ref($_[0]); 
    for(@{ $_[0] }){
      instance($_,"Catmandu::DSpace::Community");
    }
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
    #ook andere attributen: return is array van communities
    push @subCommunities,$class->from_hash_ref($subc);
  }
  my @collections = ();
  for my $c(@{ $ref->{collections} || [] }){
    push @collections,Catmandu::DSpace::Collection->from_hash_ref($c);
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
    parentCommunity => defined($ref->{parentCommunity}) ? $class->from_hash_ref($ref->{parentCommunity}) : undef,
    subCommunities => \@subCommunities
  );
}

1;
