#!/usr/bin/env perl
use Catmandu::Sane;
no autovivification;
use LWP::UserAgent;

my $ua = LWP::UserAgent->new(cookie_jar => {});
my $res = $ua->post(
  "http://localhost:8080/dspace-rest/communities.json?user=nicolas.franck\@ugent.be&pass=dspace",
  'Content-Type' => "application/json",
  Content => "{\"name\":\"Yet another community!\"}"
);
print $res->content;
