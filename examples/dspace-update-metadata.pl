#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Catmandu::DSpace;
use open qw(:std :utf8);
use Data::Dumper;

my $dspace = Catmandu::DSpace->new(
  base_url => "http://localhost:8080/dspace-rest",
  username => 'nicolas.franck@ugent.be',
  password => "dspace"
);

$dspace->update_item_metadata(
  id => 1,
  metadata => [
    {
      "name" => "dc.creator",
      "value" => "Vlaanderen Morgen, Sociale en Kulturele Vereniging Rotselaar"
    },
    {
      "name" => "dc.date",
      "value" => "1996 - 2004"
    },
    {
      "name" => "dc.date",
      "value" => "2013-02-08T10:00:25Z"
    },
    {
      "name" => "dc.identifier",
      "value" => "523"
    },
    {
      "name" => "dc.identifier",
      "value" => "BE ADVN AC0 - 2004\/321 - VEA000019"
    },
    {
      "name" => "dc.identifier",
      "value" => "http:\/\/hdl.handle.net\/123456789\/4"
    },
    {
      "name" => "dc.description",
      "value" => "Het archief omvat diverse documenten over de tweejaarlijkse Frans Drijversprijs van 1996 tot 2004."
    },
    {
      "name" => "dc.description",
      "value" => "Made available in DSpace on 2013-02-08T10:00:25Z (GMT). No. of bitstreams: 17\ndata\/Frans Drijversprijs 1996\/Toespraak M.Devillé-1996.doc: 355328 bytes, checksum: 53e6d3be1c6300d326010ab50a3d810e (MD5)\ndata\/Frans Drijversprijs 1996\/Toespraak L.Vandenberghe.doc: 775680 bytes, checksum: 84c2b8e9107b5d090f244aee3653224c (MD5)\ndata\/Frans Drijversprijs 1996\/Persartikels\/De Dorpskrant - januari 1997.doc: 341504 bytes, checksum: 97ed902a6e3e0489731a9446e6f680aa (MD5)\ndata\/Frans Drijversprijs 1996\/Persartikels\/De Dorpskrant-juli 1996.doc: 129536 bytes, checksum: fb0c52069f494df4583f11c3d62f0c01 (MD5)\ndata\/Frans Drijversprijs 1996\/Foto's\/Frans Drijversprijs 1996 foto 1.tif: 1463994 bytes, checksum: 13c1d584f5d957edcff7dc8f78bcd136 (MD5)\ndata\/Frans Drijversprijs 1996\/Persartikels\/Gazet van Antwerpen 18-10-1996.doc: 35328 bytes, checksum: f8c0341aa4e1313a8a88f0a804953508 (MD5)\ndata\/Frans Drijversprijs 1996\/Persartikels\/Het Volk 21-10-1996.doc: 410624 bytes, checksum: 864b919ecd51c671380a1ae13cde4096 (MD5)\ndata\/Frans Drijversprijs 1996\/Frans Drijversprijs 1996 uitnodiging - binnenkant.tif: 278552 bytes, checksum: 0455beeaf67f2f81ad332085c5ecb81a (MD5)\ndata\/Frans Drijversprijs 1996\/Persartikels\/Het Nieuwsblad 21-10-1996.doc: 295936 bytes, checksum: e8b2378aef8e4f369509b971cdf75b59 (MD5)\ndata\/Frans Drijversprijs 1996\/Persartikels\/'T Klokske-24-10-1996.doc: 1114112 bytes, checksum: 3b1e4c6d43d1826d94da5e068b54c6bf (MD5)\ndata\/Frans Drijversprijs 1996\/Persartikels\/Het Nieuwsblad 26-6-1996.doc: 3101696 bytes, checksum: fd16df8e961c7540dd0826c8d18e4611 (MD5)\ndata\/Frans Drijversprijs 1996\/Persartikels\/Het Laatste Nieuws 21-10-1996.doc: 139776 bytes, checksum: ccfa74319db2d9bc7313a7563987dc69 (MD5)\ndata\/Frans Drijversprijs 1996\/Persartikels\/Het Klokske 10-10-1996.doc: 1055744 bytes, checksum: 3ceb1341693a17fdf07d65b964bf0692 (MD5)\ndata\/Frans Drijversprijs 1996\/Toespraak Vik Van Nuffel-1996.doc: 173056 bytes, checksum: bb202975e21eaf527935cca66b2808b3 (MD5)\ndata\/Frans Drijversprijs 1996\/Persartikels\/De Dorpskrant - november 1996.doc: 91136 bytes, checksum: 0529442291572c92da86ea5e7cf30562 (MD5)\ndata\/Frans Drijversprijs 1996\/Persartikels\/Het Nieuwsblad  2-10-1996.doc: 3169280 bytes, checksum: 8a6318792ba9bf3485ab28592bb5d9dd (MD5)\ndata\/Frans Drijversprijs 1996\/Persartikels\/De Koerier-1996.doc: 92672 bytes, checksum: 612b00940b2048a032660f099a5b1efa (MD5)"
    },
    {
      "name" => "dc.format",
      "value" => "226 bestanden - 351,9 MB"
    },
  ]
);
