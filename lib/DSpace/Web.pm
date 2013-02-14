package DSpace::Web;
use DSpace::Sane;
use Moo;
use URI::Escape;
use LWP::UserAgent;
use Data::Util qw(:check);

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
  $method = lc($method // "get");
  my $res;
  given($method){
    when("get"){
      $res = $self->_get($path,$params);
    }
    when("post"){
      $res = $self->_post($path,$params);
    }
    when("put"){
      $res = $self->_put($path,$params);
    }
    when("delete"){
      $res = $self->_delete($path,$params);
    }
    default {
      confess "method '$method' not supported";
    }
  }
  _validate_web_response($res);
  $res;
}
sub _post {
  my($self,$path,$data)=@_;
  $self->_web->post($self->base_url().$path.".json",_construct_params_as_array($data));
}
sub _put {
  my($self,$path,$data)=@_;
  $self->_web->put($self->base_url().$path.".json",_construct_params_as_array($data));
}
sub _delete {
  my($self,$path,$data)=@_;
  my $query = _construct_query($data) || "";
  $self->_web->post($self->base_url().$path.".json?$query");
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

1;
