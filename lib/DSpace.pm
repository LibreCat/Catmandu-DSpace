package DSpace;
use DSpace::Sane;
use Moo;
use Data::Util qw(:check);

use DSpace::UnSerializable;
use DSpace::Community;
use DSpace::Communities;
use DSpace::Collection;
use DSpace::Collections;
use DSpace::User;
use DSpace::Users;
use DSpace::Group;
use DSpace::Groups;
use DSpace::Item;
use DSpace::Items;
use DSpace::Bitstream;
use DSpace::MetadataFields;
use DSpace::Bundles;
use DSpace::Harvest;

extends qw(DSpace::Web);

sub community {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for community");

  $args{$_} = "true" for(qw(parents children collections));
  $args{trim} = "false";
  my $content = $self->_do_web_request("/communities/$id",\%args,"get")->content();
  DSpace::Community->from_json($content);
}
sub communities {
  my($self,%args) = @_;
  $args{trim} = "false";
  my $content = $self->_do_web_request("/communities",\%args,"get")->content();
  DSpace::Communities->from_json($content);
}
sub collection {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";  
  is_string($id) or confess("no id given for collection");

  $args{trim} = "false";
  my $content = $self->_do_web_request("/collections/$id",\%args,"get")->content();
  DSpace::Collection->from_json($content);
}
sub collection_items {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for collection");

  my $content = $self->_do_web_request("/collections/$id/items",\%args,"get")->content();
  my $array_items = DSpace::UnSerializable::_from_json($content);
  my @items;
  for my $item(@$array_items){
    push @items,DSpace::Item->from_hash_ref($item);
  }
  \@items;
}
sub collections {
  my($self,%args) = @_;
  $args{trim} = "false";
  my $content = $self->_do_web_request("/collections",\%args,"get")->content();
  DSpace::Collections->from_json($content);
}

sub item {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for item");

  my $content = $self->_do_web_request("/items/$id",\%args,"get")->content();
  DSpace::Item->from_json($content);
}
sub items {
  my($self,%args) = @_;
  my $content = $self->_do_web_request("/items",\%args,"get")->content();
  DSpace::Items->from_json($content);
}
sub items_metadatafields {
  my $self = shift;
  my $content = $self->_do_web_request("/items/metadatafields",{},"get")->content();
  DSpace::MetadataFields->from_json($content);
}
sub item_bundles {
  my($self,%args)=@_; 
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for item");

  my $content = $self->_do_web_request("/items/$id/bundles",\%args,"get")->content();
  DSpace::Bundles->from_json($content);  
}
sub bitstream {
  my($self,%args)=@_;  
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for bitstream");

  my $content = $self->_do_web_request("/bitstreams/$id",\%args,"get")->content();
  DSpace::Bitstream->from_json($content);
}
sub bitstream_download {
  my($self,%args)=@_;  
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for bitstream");

  $self->_do_web_request("/bitstreams/$id/download",{},"get")->content_ref();
}
sub harvest {
  my($self,%args)=@_;  
  my $content = $self->_do_web_request("/harvest",\%args,"get")->content();
  DSpace::Harvest->from_json($content);
}

sub user {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for user");

  $args{user} = $self->username;
  $args{pass} = $self->password;
  my $content = $self->_do_web_request("/users/$id",\%args,"get")->content();
  DSpace::User->from_json($content);
}
sub users {
  my($self,%args) = @_;
  $args{user} = $self->username;
  $args{pass} = $self->password;
  my $content = $self->_do_web_request("/users",\%args,"get")->content();
  DSpace::Users->from_json($content);
}
sub group {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for group");

  $args{user} = $self->username;
  $args{pass} = $self->password;
  my $content = $self->_do_web_request("/groups/$id",\%args,"get")->content();
  DSpace::Group->from_json($content);
}
sub groups {
  my($self,%args) = @_;
  $args{user} = $self->username;
  $args{pass} = $self->password;
  my $content = $self->_do_web_request("/groups",\%args,"get")->content();
  DSpace::Groups->from_json($content);
}

1;
