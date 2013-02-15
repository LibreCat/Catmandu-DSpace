package Catmandu::DSpace::Collections;
use Catmandu::DSpace::Sane;
use Moo;
use Catmandu::DSpace::Collection;

with qw(Catmandu::DSpace::UnSerializable);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref,$dspace)=@_;

  my @collections = ();
  for my $collection(@{ $ref->{collections} || [] }){
    push @collections,Catmandu::DSpace::Collection->from_hash_ref($collection);
  }

  \@collections;
}

1;
