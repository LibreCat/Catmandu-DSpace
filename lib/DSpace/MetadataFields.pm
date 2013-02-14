package DSpace::MetadataFields;
use DSpace::Sane;
use Moo;
use DSpace::MetadataField;

with qw(DSpace::UnSerializable);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;

  my @metadatafields = ();
  for my $f(@{ $ref || [] }){
    push @metadatafields,DSpace::MetadataField->new(id => $f->{id},name=>$f->{name});
  }

  \@metadatafields;
}

1;
