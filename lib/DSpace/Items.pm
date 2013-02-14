package DSpace::Items;
use DSpace::Sane;
use Moo;
use DSpace::Item;

with qw(DSpace::UnSerializable);

sub from_json {
  my($class,$json,$dspace) = @_;
  $class->from_hash_ref(_from_json($json),$dspace);
}
sub from_hash_ref {
  my($class,$ref,$dspace)=@_;

  my @items = ();
  for my $item(@{ $ref->{items} || [] }){
    push @items,DSpace::Item->from_hash_ref($item,$dspace);
  }

  \@items;
}

1;
