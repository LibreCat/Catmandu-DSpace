use warnings;
use strict;
use Module::Build;

my $requires = {
  perl => '>=5.10.1',
  'JSON' => 0,
  'Moo' => 0,
  'URI::Escape' => 0,
  'LWP::UserAgent' => 0,
  'Data::Util' => 0
};
my $recommends = {};
my $build = Module::Build->new(
  module_name => 'Low level api for DSpace Rest api',
  dist_version => '0.01',
  dist_author => [
    'Nicolas Franck <nicolas.franck@ugent.be>',
  ],
  dist_abstract => 'Low level api for DSpace Rest api',
  requires => $requires,
  recommends => $recommends,
  create_license => 1
);
$build->create_build_script;
