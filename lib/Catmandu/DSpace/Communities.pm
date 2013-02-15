package Catmandu::DSpace::Communities;
use Catmandu::DSpace::Sane;
use Moo;
use Catmandu::DSpace::Community;

with qw(Catmandu::DSpace::UnSerializable);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;

  my @communities = ();
  for my $community(@{ $ref->{communities} || [] }){
    push @communities,Catmandu::DSpace::Community->from_hash_ref($community);
  }

  \@communities;
}

1;
