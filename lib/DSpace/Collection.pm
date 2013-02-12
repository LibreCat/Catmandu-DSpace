package DSpace::Collection;
use DSpace::Sane;
use Data::Util qw(:validate :check);
use Moo;

extends qw(DSpace::Object);
with qw(DSpace::JSON DSpace::HashRef);

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
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;
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
    provenance => $ref->{provenance}
  );
}

1;
