package Catmandu::DSpace::Users;
use Catmandu::DSpace::Sane;
use Moo;
use Catmandu::DSpace::User;

with qw(Catmandu::DSpace::UnSerializable);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;

  my @users = ();
  for my $user(@{ $ref->{users} || [] }){
    push @users,Catmandu::DSpace::User->from_hash_ref($user);
  }

  \@users;
}

1;
