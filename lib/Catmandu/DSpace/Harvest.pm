package Catmandu::DSpace::Harvest;
use Catmandu::DSpace::Sane;
use Data::Util qw(:validate :check);
use Moo;
use Catmandu::DSpace::Item;

with qw(Catmandu::DSpace::UnSerializable);

has id => (is => 'ro',required => 1);
has name => (is => 'ro',required => 1);
has resultsCount => (
  is => 'ro',
  isa => sub {
    my $num = shift;
    (is_integer($num) && $num >= 0) or die("resultsCount must be natural number");
  },
  required => 1
);
has items => (
  is => 'ro',
  isa => sub {
    my $array = shift;
    array_ref($array);
    instance($_,"Catmandu::DSpace::Item") for(@$array);
  },
  required => 1
);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;
  my %args = ();
  $args{$_} = $ref->{harvest}->[0]->{$_} for(qw(id name resultsCount));
  my @items;
  for(my $i = 1;$i < scalar(@{ $ref->{harvest} });$i++){
    push @items,Catmandu::DSpace::Item->from_hash_ref($ref->{harvest}->[$i]);
  }
  $args{items} = \@items;
  $class->new(%args);
}

1;
