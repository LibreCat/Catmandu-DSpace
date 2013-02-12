package DSpace::Users;
use DSpace::Sane;
use Moo;
use DSpace::User;

with qw(DSpace::JSON DSpace::HashRef);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;

  my @users = ();
  for my $user(@{ $ref->{users} || [] }){
    push @users,DSpace::User->from_hash_ref($user);
  }

  \@users;
}

1;
