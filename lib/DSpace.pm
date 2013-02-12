package DSpace;
use DSpace::Sane;
use Moo;
use URI::Escape;
use LWP::UserAgent;
use Data::Util qw(:check :validate);

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


has base_url => (
  is => 'ro',
  isa => sub { $_[0] =~ /^https?:\/\//o or die("base_url must be a valid web url\n"); },
  required => 1
);
has username => (is => 'ro');
has password => (is => 'ro');
has _web => (
  is => 'ro',
  lazy => 1,
  default => sub {
    LWP::UserAgent->new(
      cookie_jar => {}
    );
  }
);

sub _validate_web_response {
  my($res) = @_;
  $res->is_error && confess($res->content);
}
sub _do_web_request {
  my($self,$path,$params,$method)=@_;
  $method ||= "GET";
  my $res;
  if(uc($method) eq "GET"){
    $res = $self->_get($path,$params);
  }elsif(uc($method) eq "POST"){
    $res = $self->_post($path,$params);
  }else{
    confess "method $method not supported";
  }
  _validate_web_response($res);
  $res;
}
sub _post {
  my($self,$path,$data)=@_;
  $self->_web->post($self->base_url().$path.".json",_construct_params_as_array($data));
}
sub _get {
  my($self,$path,$data)=@_;
  my $query = _construct_query($data) || "";
  $self->_web->get($self->base_url().$path.".json?$query");
}
sub _construct_query {
  my $data = shift;
  my @parts = ();
  for my $key(keys %$data){
    if(is_array_ref($data->{$key})){
      for my $val(@{ $data->{$key} }){
          push @parts,URI::Escape::uri_escape($key)."=".URI::Escape::uri_escape($val // "");
      }
    }else{
      push @parts,URI::Escape::uri_escape($key)."=".URI::Escape::uri_escape($data->{$key} // "");
    }
  }
  join("&",@parts);
}
sub _construct_params_as_array {
  my $params = shift;
  my @array = ();
  for my $key(keys %$params){
    if(is_array_ref($params->{$key})){
      #PHP only recognizes 'arrays' when their keys are appended by '[]' (yuk!)
      for my $val(@{ $params->{$key} }){
        push @array,$key."[]" => $val;
      }
    }else{
      push @array,$key => $params->{$key};
    }
  }
  return \@array;
}

sub community {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  my $content = $self->_do_web_request("/communities/$id",\%args,"get")->content();
  DSpace::Community->from_json($content);
}
sub communities {
  my($self,%args) = @_;
  my $content = $self->_do_web_request("/communities",\%args,"get")->content();
  DSpace::Communities->from_json($content);
}
sub collection {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  my $content = $self->_do_web_request("/collections/$id",\%args,"get")->content();
  DSpace::Collection->from_json($content);
}
sub collections {
  my($self,%args) = @_;
  my $content = $self->_do_web_request("/collections",\%args,"get")->content();
  DSpace::Collections->from_json($content);
}
sub user {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
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
sub item {
  my($self,%args)=@_;
  my $id = (delete $args{id}) // "";
  my $content = $self->_do_web_request("/items/$id",\%args,"get")->content();
  DSpace::Item->from_json($content);
}
sub items {
  my($self,%args) = @_;
  my $content = $self->_do_web_request("/items",\%args,"get")->content();
  DSpace::Items->from_json($content);
}
sub bitstream {
  my($self,%args)=@_;  
  my $id = (delete $args{id}) // "";
  my $content = $self->_do_web_request("/bitstreams/$id",\%args,"get")->content();
  DSpace::Bitstream->from_json($content);
}
#todo: /bitstreams geeft { "bitstreams": [] }
sub bitstream_bundles {

}
1;
