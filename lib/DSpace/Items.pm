package DSpace::Items;
use DSpace::Sane;
use Moo;
use DSpace::Item;

with qw(DSpace::JSON DSpace::HashRef);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;

  my @items = ();
  for my $item(@{ $ref->{items} || [] }){
    push @items,DSpace::Item->from_hash_ref($item);
  }

  \@items;
}

1;
