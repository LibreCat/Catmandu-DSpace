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

extends qw(Catmandu::DSpace::Web);

#reader methods
sub community {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for community");

  $args{$_} = "true" for(qw(parents children collections));
  $args{trim} = "false";
  my $content = $self->_do_web_request(path => "/communities/$id",params => \%args,method => "get")->content();
  Catmandu::DSpace::Community->from_json($content);
}
sub communities {
  my($self,%args) = @_;
  $args{trim} = "false";
  my $content = $self->_do_web_request(path => "/communities",params => \%args,method => "get")->content();
  Catmandu::DSpace::Communities->from_json($content);
}
sub collection {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";  
  is_string($id) or confess("no id given for collection");

  $args{trim} = "false";
  my $content = $self->_do_web_request(path => "/collections/$id",params => \%args,method => "get")->content();
  Catmandu::DSpace::Collection->from_json($content);
}
sub collection_items {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for collection");

  my $content = $self->_do_web_request(path => "/collections/$id/items",params => \%args,method => "get")->content();
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
  my $content = $self->_do_web_request(path => "/collections",params => \%args,method => "get")->content();
  Catmandu::DSpace::Collections->from_json($content);
}

sub item {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for item");

  my $content = $self->_do_web_request(path => "/items/$id",params => \%args,method => "get")->content();
  Catmandu::DSpace::Item->from_json($content);
}
sub items {
  my($self,%args) = @_;
  my $content = $self->_do_web_request(path => "/items",params => \%args,method => "get")->content();
  Catmandu::DSpace::Items->from_json($content);
}
sub items_metadatafields {
  my $self = shift;
  my $content = $self->_do_web_request(path => "/items/metadatafields",method => "get")->content();
  Catmandu::DSpace::MetadataFields->from_json($content);
}
sub item_bundles {
  my($self,%args)=@_; 
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for item");

  my $content = $self->_do_web_request(path => "/items/$id/bundles",params => \%args,method => "get")->content();
  Catmandu::DSpace::Bundles->from_json($content);  
}
sub bitstream {
  my($self,%args)=@_;  
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for bitstream");

  my $content = $self->_do_web_request(path => "/bitstreams/$id",params => \%args,method => "get")->content();
  Catmandu::DSpace::Bitstream->from_json($content);
}
sub bitstream_download {
  my($self,%args)=@_;  
  my $id = (delete $args{id}) // "";
  is_string($id) or confess("no id given for bitstream");

  $self->_do_web_request(path => "/bitstreams/$id/download")->content_ref();
}
sub harvest {
  my($self,%args)=@_;  
  my $content = $self->_do_web_request(path => "/harvest",params => \%args,method => "get")->content();
  Catmandu::DSpace::Harvest->from_json($content);
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
  is_string($community->{name}) or die("name is mandatory for new community");
  
  my $id = (delete $args{id}) // "";
  is_string($id) or die("id is mandatory to delete community");

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

1;