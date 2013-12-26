#!usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use JSON qw( decode_json ); 
use Data::Dumper;
my $temp ="";
my $hum ="";
my $url = "http://api.openweathermap.org/data/2.5/weather?q=cologne,germany&units=metric";

my $json = get($url);
die "Can't GET $url" if (! defined $json);
my $decoded_json = decode_json( $json );
print Dumper($decoded_json);

$temp = $decoded_json->{main}->{temp};
$hum = $decoded_json->{main}->{humidity};

print $temp."\n";
1;
