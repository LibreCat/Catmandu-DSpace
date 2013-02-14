package DSpace::Bundles;
use DSpace::Sane;
use Moo;
use DSpace::Bundle;

with qw(DSpace::UnSerializable);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;

  my @bundles = ();
  for my $bundle(@$ref){
    push @bundles,DSpace::Bundle->from_hash_ref($bundle);
  }

  \@bundles;
}

1;
