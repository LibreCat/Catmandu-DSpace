package Catmandu::DSpace::Collection;
use Catmandu::DSpace::Sane;
use Data::Util qw(:validate :check);
use Moo;

extends qw(Catmandu::DSpace::Object);
with qw(Catmandu::DSpace::UnSerializable);

has shortDescription => (is => 'ro');
has introductoryText => (is => 'ro');
has sidebarText => (is => 'ro');
has copyrightText => (is => 'ro');
has communities => (
  is => 'ro',
  isa => sub { 
    array_ref($_[0]); 
  },
  lazy => 1,
  default => sub { []; }
);
has licence => (is => 'ro');
has provenance => (is => 'ro');

sub from_json {
  my($class,$json,$dspace) = @_;
  $class->from_hash_ref(_from_json($json),$dspace);
}
sub from_hash_ref {
  my($class,$ref,$dspace)=@_;
  my @communities = ();
  for my $c(@{ $ref->{communities} || [] }){
    push @communities,$c->{id};
  }
  $class->new(
    id => $ref->{id},
    handle => $ref->{handle},
    name => $ref->{name},
    shortDescription => $ref->{shortDescription},
    introductoryText => $ref->{introductoryText}, 
    sidebarText => $ref->{sidebarText},
    copyrightText => $ref->{copyrightText},
    communities => \@communities,
    licence => $ref->{licence},
    provenance => $ref->{provenance},
  );
}

1;
