package Catmandu::DSpace::UnSerializable;
use Catmandu::DSpace::Sane;
use Moo::Role;
use JSON qw();

sub json {
  #expect strings, not binary utf8, so disable utf8 flag! 
  #this to mimic from_json / to_json
  state $json = JSON->new->utf8(0);
}
sub _from_json {
  json()->decode($_[0]);
}

requires qw(from_json from_hash_ref);

1;
