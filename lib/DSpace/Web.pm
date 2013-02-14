package DSpace::Web;
use DSpace::Sane;
use Moo;
use URI::Escape;
use LWP::UserAgent;
use Data::Util qw(:check);
use JSON qw(encode_json decode_json);

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
  my($self,%args)=@_;
  $args{method} = lc($args{method} // "get");
  $args{params} = is_hash_ref($args{params}) ? $args{params} : {};
  $args{path} = $args{path} // "";
  $args{content} = $args{content} // "";

  my $res;
  given($args{method}){
    when("get"){
      $res = $self->_get(%args);
    }
    when("post"){
      $res = $self->_post(%args);
    }
    when("put"){
      $res = $self->_put(%args);
    }
    when("delete"){
      $res = $self->_delete(%args);
    }
    default {
      confess "method '$args{method}' not supported";
    }
  }
  _validate_web_response($res);
  $res;
}
sub _post {
  my($self,%args)=@_;
  my $url = $self->base_url().$args{path}.".json";
  my $data;
  if(defined($args{content})){
    $data = encode_json($args{content});
    $url .= "?" . _construct_query($args{params});
  }else{
    $data =  _construct_params_as_array($args{params});
  }
  $self->_web->post(
    $url,
    'Content-Type' => "application/json",
    Content => $data
  );
}
sub _put {
  my($self,%args)=@_;
  my $url = $self->base_url().$args{path}.".json";
  my $data;
  if(defined($args{content})){ 
    $data = encode_json($args{content}); 
    $url .= "?" . _construct_query($args{params});
  }else{
    $data =  _construct_params_as_array($args{params});
  }

  $self->_web->put(
    $url,
    'Content-Type' => "application/json",
    Content => $data
  );
}
sub _delete {
  my($self,%args)=@_;
  my $query = _construct_query($args{params}) || "";
  $self->_web->delete($self->base_url().$args{path}.".json?$query");
}
sub _get {
  my($self,%args)=@_;
  my $query = _construct_query($args{params}) || "";
  $self->_web->get($self->base_url().$args{path}.".json?$query");
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

1;
