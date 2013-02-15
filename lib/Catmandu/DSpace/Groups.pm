package Catmandu::DSpace::Groups;
use Catmandu::DSpace::Sane;
use Moo;
use Catmandu::DSpace::Group;

with qw(Catmandu::DSpace::UnSerializable);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;

  my @groups = ();
  for my $group(@{ $ref->{groups} || [] }){
    push @groups,Catmandu::DSpace::Group->from_hash_ref($group);
  }

  \@groups;
}

1;
