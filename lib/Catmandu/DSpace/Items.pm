package Catmandu::DSpace::Items;
use Catmandu::DSpace::Sane;
use Moo;
use Catmandu::DSpace::Item;

with qw(Catmandu::DSpace::UnSerializable);

sub from_json {
  my($class,$json,$dspace) = @_;
  $class->from_hash_ref(_from_json($json),$dspace);
}
sub from_hash_ref {
  my($class,$ref,$dspace)=@_;

  my @items = ();
  for my $item(@{ $ref->{items} || [] }){
    push @items,Catmandu::DSpace::Item->from_hash_ref($item,$dspace);
  }

  \@items;
}

1;
