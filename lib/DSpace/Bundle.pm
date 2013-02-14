package DSpace::Bundle;
use DSpace::Sane;
use Data::Util qw(:validate :check);
use Moo;
use DSpace::Bitstream;

with qw(DSpace::UnSerializable);

has bitstreams => (
  is => 'ro',
  isa => sub {
    my $array = shift;
    array_ref($array);
    instance($_,"DSpace::Bitstream") for(@$array);
  },
  required => 1
);
has name => (is => 'ro',required => 1);
has id => (is => 'ro',required => 1);
has primaryBitstreamId => (is => 'ro',required => 1);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;
  my %args = ();
  $args{$_} = $ref->{$_} for(qw(id name primaryBitstreamId));

  my @bitstreams = ();
  for my $bitstream(@{ $ref->{bitstreams} // [] }){
    push @bitstreams,DSpace::Bitstream->from_hash_ref($bitstream);   
  }
  $args{'bitstreams'} = \@bitstreams;

  $class->new(%args);
}

1;
