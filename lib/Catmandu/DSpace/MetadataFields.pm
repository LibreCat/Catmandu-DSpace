package Catmandu::DSpace::MetadataFields;
use Catmandu::DSpace::Sane;
use Moo;
use Catmandu::DSpace::MetadataField;

with qw(Catmandu::DSpace::UnSerializable);

sub from_json {
  my($class,$json) = @_;
  $class->from_hash_ref(_from_json($json));
}
sub from_hash_ref {
  my($class,$ref)=@_;

  my @metadatafields = ();
  for my $f(@{ $ref || [] }){
    push @metadatafields,Catmandu::DSpace::MetadataField->new(id => $f->{id},name=>$f->{name});
  }

  \@metadatafields;
}

1;
