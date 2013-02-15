package Catmandu::DSpace::Bitstream;
use Catmandu::DSpace::Sane;
use Data::Util qw(:validate :check);
use Moo;

with qw(Catmandu::DSpace::UnSerializable);

has id => (is => 'ro',required => 1);
has name => (is => 'ro',required => 1);
has checkSum => (is => 'ro',required => 1);
has checkSumAlgorithm => (is => 'ro',required => 1);
has description => (is => 'ro');
has mimeType => (is => 'ro',required => 1);
has sequenceId => (
  is => 'ro',
  isa => sub {
    my $num = shift;
    (is_integer($num) && $num >= 0) or die("sequenceId must be natural number");
  },
  required => 1
);
has size => (
  is => 'ro',
  isa => sub {
    my $num = shift;
    (is_integer($num) && $num >= 0) or die("size must be natural number");
  },
  required => 1
);
has source=> (is => 'ro');
has storeNumber => (
  is => 'ro',
  isa => sub {
    my $num = shift;
    (is_integer($num) && $num >= 0) or die("storeNumber must be natural number");
  },
  required => 1
);
has userFormatDescription => (is => 'ro');
has formatDescripion => (is => 'ro');

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;
  my %args = ();
  $args{$_} = $ref->{$_} for(qw(id name checkSum checkSumAlgorithm description formatDescription mimeType sequenceId size source storeNumber));
  $class->new(%args);
}

1;
