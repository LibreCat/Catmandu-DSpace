package DSpace::Collections;
use DSpace::Sane;
use Moo;
use DSpace::Collection;

with qw(DSpace::JSON DSpace::HashRef);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;

  my @collections = ();
  for my $collection(@{ $ref->{collections} || [] }){
    push @collections,DSpace::Collection->from_hash_ref($collection);
  }

  \@collections;
}

1;
