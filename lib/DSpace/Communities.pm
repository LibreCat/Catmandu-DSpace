package DSpace::Communities;
use DSpace::Sane;
use Moo;
use DSpace::Community;

with qw(DSpace::JSON DSpace::HashRef);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;

  my @communities = ();
  for my $community(@{ $ref->{communities} || [] }){
    push @communities,DSpace::Community->from_hash_ref($community);
  }

  \@communities;
}

1;
