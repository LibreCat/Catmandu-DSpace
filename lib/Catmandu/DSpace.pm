package Catmandu::DSpace;
use Catmandu::DSpace::Sane;
use Moo;
use JSON qw(encode_json decode_json);
use Data::Util qw(:check :validate);

use Catmandu::DSpace::Community;
use Catmandu::DSpace::Communities;
use Catmandu::DSpace::Collection;
use Catmandu::DSpace::Collections;
use Catmandu::DSpace::User;
use Catmandu::DSpace::Users;
use Catmandu::DSpace::Group;
use Catmandu::DSpace::Groups;
use Catmandu::DSpace::Item;
use Catmandu::DSpace::Items;
use Catmandu::DSpace::Bitstream;
use Catmandu::DSpace::MetadataFields;
use Catmandu::DSpace::Bundles;
use Catmandu::DSpace::Harvest;
use Catmandu::DSpace::Search;

extends qw(Catmandu::DSpace::Web);

#reader methods
sub community {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for community");

  $args{$_} = "true" for(qw(parents children collections));
  $args{trim} = "false";
  my $content = $self->_do_web_request(path => "/communities/$id",params => \%args)->content();
  Catmandu::DSpace::Community->from_json($content);
}
sub communities {
  my($self,%args) = @_;
  $args{trim} = "false";
  my $content = $self->_do_web_request(path => "/communities",params => \%args)->content();
  Catmandu::DSpace::Communities->from_json($content);
}
sub collection {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";  
  is_string($id) or confess("no id given for collection");

  $args{trim} = "false";
  my $content = $self->_do_web_request(path => "/collections/$id",params => \%args)->content();
  Catmandu::DSpace::Collection->from_json($content);
}
sub collection_items {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for collection");

  my $content = $self->_do_web_request(path => "/collections/$id/items",params => \%args)->content();
  my $array_items = decode_json($content);
  my @items;
  for my $item(@$array_items){
    push @items,Catmandu::DSpace::Item->from_hash_ref($item);
  }
  \@items;
}
sub collections {
  my($self,%args) = @_;
  $args{trim} = "false";
  my $content = $self->_do_web_request(path => "/collections",params => \%args)->content();
  Catmandu::DSpace::Collections->from_json($content);
}

sub item {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for item");

  my $content = $self->_do_web_request(path => "/items/$id",params => \%args)->content();
  Catmandu::DSpace::Item->from_json($content);
}
sub items {
  my($self,%args) = @_;
  my $content = $self->_do_web_request(path => "/items",params => \%args)->content();
  Catmandu::DSpace::Items->from_json($content);
}
sub items_metadatafields {
  my $self = shift;
  my $content = $self->_do_web_request(path => "/items/metadatafields")->content();
  Catmandu::DSpace::MetadataFields->from_json($content);
}
sub item_bundles {
  my($self,%args)=@_; 
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for item");

  my $content = $self->_do_web_request(path => "/items/$id/bundles",params => \%args)->content();
  Catmandu::DSpace::Bundles->from_json($content);  
}
sub bitstream {
  my($self,%args)=@_;  
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for bitstream");

  my $content = $self->_do_web_request(path => "/bitstreams/$id",params => \%args)->content();
  Catmandu::DSpace::Bitstream->from_json($content);
}
sub bitstream_download {
  my($self,%args)=@_;  
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for bitstream");

  $self->_do_web_request(path => "/bitstreams/$id/download",%args)->content_ref();
}
sub harvest {
  my($self,%args)=@_;  
  my $content = $self->_do_web_request(path => "/harvest",params => \%args)->content();
  Catmandu::DSpace::Harvest->from_json($content);
}
sub search {
  my($self,%args)=@_;  
  my $content = $self->_do_web_request(path => "/search",params => \%args)->content();
  Catmandu::DSpace::Search->from_json($content);
}
sub user {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for user");

  $args{user} = $self->username;
  $args{pass} = $self->password;
  my $content = $self->_do_web_request(path => "/users/$id",params => \%args)->content();
  Catmandu::DSpace::User->from_json($content);
}
sub users {
  my($self,%args) = @_;
  $args{user} = $self->username;
  $args{pass} = $self->password;
  my $content = $self->_do_web_request(path => "/users",params => \%args)->content();
  Catmandu::DSpace::Users->from_json($content);
}
sub group {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for group");

  $args{user} = $self->username;
  $args{pass} = $self->password;
  my $content = $self->_do_web_request(path => "/groups/$id",params => \%args)->content();
  Catmandu::DSpace::Group->from_json($content);
}
sub groups {
  my($self,%args) = @_;
  $args{user} = $self->username;
  $args{pass} = $self->password;
  my $content = $self->_do_web_request(path => "/groups",params => \%args)->content();
  Catmandu::DSpace::Groups->from_json($content);
}


#edit methods
sub add_community {
  my($self,%args)=@_;

  my $community = delete $args{community};
  hash_ref($community);
  is_string($community->{name}) or die("name is mandatory for new community");
 
  $args{user} = $self->username;
  $args{pass} = $self->password;

  #return value: id of new community
  $self->_do_web_request(
    path => "/communities",
    content => $community,
    method => "post",
    params => \%args
  )->content();
}
sub update_community {
  my($self,%args)=@_;

  my $community = delete $args{community};
  hash_ref($community);
  is_string($community->{name}) or die("name is mandatory to update community");
  
  my $id = (delete $args{id}) // "";
  is_string($id) or die("id is mandatory to update community");

  $args{user} = $self->username;
  $args{pass} = $self->password;

  $self->_do_web_request(
    path => "/communities/$id",
    content => $community,
    method => "put",
    params => \%args
  )->content();
}
sub delete_community {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or die("id is mandatory to delete community");
  
  $args{user} = $self->username;
  $args{pass} = $self->password;
 
  $self->_do_web_request(
    path => "/communities/$id",
    method => "delete",
    params => \%args
  );
}
sub add_collection {
  my($self,%args)=@_;

  my $collection = delete $args{collection};
  hash_ref($collection);
  for(qw(name communityId)){
    is_string($collection->{$_}) or die("'$_' is mandatory for new collection");
  }
 
  $args{user} = $self->username;
  $args{pass} = $self->password;

  #return value: id of new collection
  $self->_do_web_request(
    path => "/collections",
    content => $collection,
    method => "post",
    params => \%args
  )->content();

}
sub update_colllection {
  my($self,%args)=@_;

  my $collection = delete $args{collection};
  hash_ref($collection);
  is_string($collection->{name}) or die("name is mandatory to update collection");
  
  my $id = (delete $args{id}) // "";
  is_string($id) or die("id is mandatory to update collection");

  $args{user} = $self->username;
  $args{pass} = $self->password;

  $self->_do_web_request(
    path => "/collections/$id",
    content => $collection,
    method => "put",
    params => \%args
  )->content();
}
sub delete_collection {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or die("id is mandatory to delete collection");
  
  $args{user} = $self->username;
  $args{pass} = $self->password;
 
  $self->_do_web_request(
    path => "/collections/$id",
    method => "delete",
    params => \%args
  );
}
sub update_item_metadata {
  my($self,%args)=@_;

  my $id = (delete $args{id}) // "";
  is_string($id) or die("id is mandatory to update metadata of an item");

  $args{user} = $self->username;
  $args{pass} = $self->password; 

  my $metadata = delete $args{metadata};
  array_ref($metadata);
  for my $field(@$metadata){
    hash_ref($field);
  }

  $self->_do_web_request(
    path => "/items/$id/metadata",
    method => "put",
    params => \%args,
    content => { metadata => $metadata }
  );
}
sub delete_item_metadata {
  my($self,%args)=@_;

  my $id = (delete $args{id}) // "";
  is_string($id) or die("id is mandatory to delete metadata field of an item");

  my $metadata_id = (delete $args{metadata_id}) // "";
  is_string($metadata_id) or die("metadata_id is mandatory to delete metadata field of an item");

  $args{user} = $self->username;
  $args{pass} = $self->password; 

  $self->_do_web_request(
    path => "/items/$id/metadata/$metadata_id",
    method => "delete",
    params => \%args
  );
}

=head1 NAME

  Catmandu::DSpace - a low level client for the DSpace Rest API

=head1 SYNOPSIS

=head1 METHODS
 

=head2 new

  parameters:
    base_url (required): base url of the dspace rest api
    username (required)
    password (required)

=head2 communities

  return value: array reference of L<Catmandu::DSpace::Community> objects

=head2 community

  parameters:

    id (required): identifier of the community

  return value: L<Catmandu::DSpace::Community> object

=head2 collections

  parameters:

    start (optional): position of the first record in the list. Default '0'
    limit (optional): number of records to return. Default all records

  return value: array reference of L<Catmandu::DSpace::Collection> objects

=head2 collection

  parameters:

    id (required): identifier of the collection

  return value: L<Catmandu::DSpace::Collection> object

=head2 collection_items

  parameters:
    
    id (required): identifier of the collection
    start (optional): position of the first record in the list. Default '0'
    limit (optional): number of records to return. Default all records

  return value: array reference of L<Catmandu::DSpace::Item> objects that belong to
                the given collection

=head2 items

  parameters:
    
    start (optional): position of the first record in the list. Default '0'
    limit (optional): number of records to return. Default all records

  return value: array reference of L<Catmandu::DSpace::Item> objects

=head2 item

  parameters:

    id (required): identifier of the item

  return value: L<Catmandu::DSpace::Item> object

=head2 item_metadatafields

  return value: array reference of L<Catmandu::DSpace::MetadataField> objects.
                These objects describe the available metadata fields by name
                and id.

=head2 item_bundles

  parameters:

    id (required): identifier of the item
    type (optional): The bitstream type to retrieve. Available types are ORIGINAL, THUMBNAIL, PREVIEW, LICENSE and SWORD.
                     The default is all bitstream types.

  return value: array reference of L<Catmandu::DSpace::Bundle> objects.
                Each bundle contains a list of L<Catmandu::DSpace::Bitstream> objects. 

=head2 bitstream

  parameters:

    id (required): identifier of the bistream

  return value: L<Catmandu::DSpace::Bitstream> object

=head2 bitstream_download

  parameters:

    id (required): identifier of the bitstream
    callback (optional): when supplied, the content is streamed and delivered in chunks to this function
                         this method receives tree arguments: chunck, L<HTTP::Response> object and protocol name.

  return value: scalar reference to raw content of the bitstream. When the callback is given, the return is empty.
 
=head2 harvest

  harvest items from dspace. Restrict the returned items by use of the parameters.

  parameters:
    
    collection (optional): identifier of the collection.
    community (optional): identifier of the community.
    withdrawn (optional): true/false. 

    'collection' and 'community' are mutually exclusive.

=cut
1;
