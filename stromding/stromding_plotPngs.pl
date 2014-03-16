#!/usr/bin/perl
use strict;
use warnings;
use GD;
use DBI;
use Data::Dumper;
use Date::Simple;

# Database info
my $db_name     = "digitemp";
my $db_user     = "dt_logger";
my $db_pass     = "lololo";

# Connect to the database
my $dbh = DBI->connect("dbi:mysql:$db_name","$db_user","$db_pass") or die "I cannot connect to dbi:mysql:$db_name as $db_user - $DBI::errstr\n";


  #`power` WATTL,
  #`voltage` VOLT ,
  #`current` AMPERE,
  #`energy` kWH,


my $queryString= 'select name, time, power, voltage,current, energy from stromding;';
my $query = $dbh->prepare($queryString);
$query->execute() or die $query->err_str;

my $unsortedTimes = ();
my $wattByTime = {};
my $name = "";
while (my $res = $query->fetchrow_hashref() ) {
	$name = $res->{name};
	$wattByTime->{$res->{time}} = $res->{power};
	$unsortedTimes->{$res->{time}} = 1;
}
my @sortedTimes  = sort{ $a cmp $b } keys %$unsortedTimes;

#=================================================================
#=================================================================
#   Write  PNG for stromding
#=================================================================
#=================================================================
#1. write csv file with all sensors	
my $minDate =$sortedTimes[0];
my $maxDate =$sortedTimes[$#sortedTimes];
my $minWatt = 0,
my $maxWatt = 0,
my $numEntries = 0;
my $csvFilename ='/tmp/stromding.dat';
open (CSV, ">$csvFilename");
foreach my $time (@sortedTimes){
	print CSV "$time,";
	my $watt = $wattByTime->{$time};
	print CSV "$watt,";
	$maxWatt = $watt if($watt>$maxWatt);
	print CSV "\n";
	$numEntries++;
}	
close CSV;
$maxWatt += 20;
	
#2. write gnuplot file for csv file	
my $gnuplotFilename="/tmp/stromding.gp";
my $pngFilename = "/tmp/stromding.png";
my $title = "Stromverbrauch Bettakomben-Raum insgesamt";
open (GNUPLOT, ">$gnuplotFilename");
print GNUPLOT '#set key out vert'."\n";
print GNUPLOT '#set key right top'."\n";
print GNUPLOT 'set datafile separator ","'."\n";
print GNUPLOT 'set xdata time'."\n";
print GNUPLOT 'set timefmt "%Y-%m-%d %H:%M:%S"'."\n";
print GNUPLOT 'set format x "%d%h \n %H:%M"'."\n";
print GNUPLOT 'set xrange [ "'.$minDate.'" : "'.$maxDate.'" ]'."\n";
#print GNUPLOT 'set autoscale y '."\n";
print GNUPLOT 'set yrange [ '.($minWatt).' : '.($maxWatt).' ]'."\n";
print GNUPLOT 'set ytics auto'."\n";
print GNUPLOT 'set ylabel "Watt"'."\n";
print GNUPLOT 'set y2range [ '.($minWatt).' : '.($maxWatt).' ]'."\n";
print GNUPLOT 'set y2tics auto'."\n";
print GNUPLOT 'set y2label "Watt"'."\n";
print GNUPLOT 'set mxtics 4'."\n";
print GNUPLOT 'set mytics 2'."\n";
print GNUPLOT 'set grid x y'."\n";
print GNUPLOT 'set xlabel "Datum und Uhrzeit"'."\n";
print GNUPLOT 'set title  "'.$title.'"'."\n";
print GNUPLOT 'set output "'.$pngFilename.'"'."\n";
print GNUPLOT 'set style fill solid border -1'."\n";
print GNUPLOT 'set style line 1 lt 2 lw 1'."\n";
print GNUPLOT 'set pointsize .2'."\n";
print GNUPLOT '#set sample 45'."\n";
print GNUPLOT 'set terminal png size 800,400'."\n";
print GNUPLOT 'set terminal png'."\n";

my $plotString = 'plot "'.$csvFilename.'" using 1:2 with lines notitle'; #title "'.$title.'" with lines ';

print GNUPLOT $plotString."\n";

close GNUPLOT;

#---------------------------------------------------------------------
#3. run gnuplot and copy png image to www directory and change rights	
#---------------------------------------------------------------------
system ("gnuplot $gnuplotFilename");
system ("chown www-data:www-data $pngFilename && cp $pngFilename /var/www/img/" );

print "'ALL' :$numEntries csv entries, gnuplottet $gnuplotFilename into $pngFilename.\n";








1;
