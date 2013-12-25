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


my $queryString= 'select t.SerialNumber, t.time, t.Temp, s.name from digitemp t, sensors s where t.SerialNumber = s.serial;';
my $query = $dbh->prepare($queryString);
$query->execute() or die $query->err_str;

#2013-12-06 22:52:54,22.38,Serverschrank
my $sensorNamesBySerial = {};
my $sensors = ();
my $tempBySensors = {};
my $unsortedTimes = ();
my $tempByTime = {};
while (my $res = $query->fetchrow_hashref() ) {
	#print "SerialNumber=$res->{SerialNumber},time=$res->{time}, Temp=$res->{Temp}, name=$res->{name} \n";
	$tempBySensors->{$res->{SerialNumber}}->{$res->{time}} = $res->{Temp};
	$tempByTime->{$res->{time}}->{$res->{SerialNumber}} = $res->{Temp};
	$sensors->{$res->{SerialNumber}} = 1;
	$unsortedTimes->{$res->{time}} = 1;
	$sensorNamesBySerial->{$res->{SerialNumber}} = $res->{name};
}
my @sortedSensors = sort{ $a cmp $b } keys %$sensors;
my @sortedTimes  = sort{ $a cmp $b } keys %$unsortedTimes;

#=================================================================
#=================================================================
#   Write 1 PNG for all sensors
#=================================================================
#=================================================================
#1. write csv file with all sensors	
my $minDate =$sortedTimes[0];
my $maxDate =$sortedTimes[$#sortedTimes];
my $minTemp = 30;
my $maxTemp = 0,
my $numEntries = 0;
my $csvFilename ='temp_all.dat';
open (CSV, ">$csvFilename");
foreach my $time (@sortedTimes){
	print CSV "$time,";
	foreach my $sensor (@sortedSensors){
		if(defined($tempByTime->{$time}->{$sensor})){
			my $temp = $tempByTime->{$time}->{$sensor};
			print CSV "$temp,";
			$minTemp = $temp if($temp<$minTemp);
			$maxTemp = $temp if($temp>$maxTemp);
		}else{
			print CSV '"",';
		}
	}
	print CSV "\n";
	$numEntries++;
}	
close CSV;
$maxTemp = 40;
	
#2. write gnuplot file for csv file	
my $gnuplotFilename="temp_all.gp";
my $pngFilename = "temp_all.png";
open (GNUPLOT, ">$gnuplotFilename");
print GNUPLOT 'set datafile separator ","'."\n";
print GNUPLOT 'set xdata time'."\n";
print GNUPLOT 'set timefmt "%Y-%m-%d %H:%M:%S"'."\n";
print GNUPLOT 'set format x "%d/%h%H:%M"'."\n";
print GNUPLOT 'set xrange [ "'.$minDate.'" : "'.$maxDate.'" ]'."\n";
print GNUPLOT '#set autoscale y '."\n";
print GNUPLOT 'set yrange [ '.($minTemp-2).' : '.($maxTemp+2).' ]'."\n";
print GNUPLOT 'set ytics out mirror 2'."\n";
print GNUPLOT 'set ylabel "Grad Celsius"'."\n";
print GNUPLOT 'set y2range [ '.($minTemp-2).' : '.($maxTemp+2).' ]'."\n";
print GNUPLOT 'set y2tics out mirror 2'."\n";
print GNUPLOT 'set y2label "Grad Celsius"'."\n";
print GNUPLOT 'set mxtics 4'."\n";
print GNUPLOT 'set mytics 2'."\n";
print GNUPLOT 'set grid x y'."\n";
print GNUPLOT 'set xlabel "Datum und Uhrzeit"'."\n";
print GNUPLOT 'set title "Alle Temperatur-Sensoren"'."\n";
print GNUPLOT 'set output "'.$pngFilename.'"'."\n";
print GNUPLOT 'set style fill solid border -1'."\n";
print GNUPLOT 'set style line 1 lt 2 lw 1'."\n";
print GNUPLOT 'set pointsize .2'."\n";
print GNUPLOT 'set sample 45'."\n";
print GNUPLOT 'set terminal png size 1024,600'."\n";
print GNUPLOT 'set terminal png'."\n";
my $plotString = 'plot '; 
my $csvIndex=2;
foreach my $sensor(@sortedSensors){
	my $sensorName = $sensorNamesBySerial->{$sensor} || $sensor;
	$plotString .= '"'.$csvFilename.'" using 1:'.$csvIndex.' title "'.$sensorName.'"  with lines, ';
	$csvIndex++;
}
$plotString =~ s/,$//;
print GNUPLOT $plotString."\n";

close GNUPLOT;

#---------------------------------------------------------------------
#3. run gnuplot and copy png image to www directory and change rights	
#---------------------------------------------------------------------
system ("gnuplot $gnuplotFilename");
system ("chown www-data:www-data $pngFilename && cp $pngFilename /var/www/img/" );

print "'ALL' :$numEntries csv entries, gnuplottet $gnuplotFilename into $pngFilename.\n";










#=================================================================
#=================================================================
#   Write x PNGs for x sensors
#=================================================================
#=================================================================

my $sensorCount = 0;
foreach my $sensor (keys %$tempBySensors){
	$sensorCount++;
	my $sensorName = $sensorNamesBySerial->{$sensor} || $sensor;
	
	#---------------------------------------------------------
	#1. write csv file with sorted times	
	#---------------------------------------------------------
	my $csvFilename ='temp'.$sensorCount.'.dat';
	open (CSV, ">$csvFilename");
	my $numEntries = 0;
	my @unsortedTimes1 = keys %{$tempBySensors->{$sensor}};
	my @sortedTimes1  = sort{ $a cmp $b } @unsortedTimes1;
	my $minTemp = 30;
	my $maxTemp = 0;
	foreach my $time (@sortedTimes1){
		print CSV "$time,$tempBySensors->{$sensor}->{$time}, $sensor \n";
		$minTemp = $tempBySensors->{$sensor}->{$time} if($tempBySensors->{$sensor}->{$time}<$minTemp);
		$maxTemp = $tempBySensors->{$sensor}->{$time} if($tempBySensors->{$sensor}->{$time}>$maxTemp);
		$numEntries++;
	}
	my $minDate1 =$sortedTimes1[0];
	my $maxDate1 =$sortedTimes1[$#sortedTimes1];
	
	close CSV;
	
	#---------------------------------------------------------
	#2. write gnuplot file for csv file	
	#---------------------------------------------------------
	my $gnuplotFilename="temp".$sensorCount.".gp";
	my $pngFilename = "temp".$sensorCount.".png";
	open (GNUPLOT, ">$gnuplotFilename");
	print GNUPLOT 'set datafile separator ","'."\n";
	print GNUPLOT 'set xdata time'."\n";
	print GNUPLOT 'set timefmt "%Y-%m-%d %H:%M:%S"'."\n";
	print GNUPLOT 'set format x "%d %h%H:%M"'."\n";
	print GNUPLOT 'set xrange [ "'.$minDate1.'" : "'.$maxDate1.'" ]'."\n";
	print GNUPLOT '#set autoscale y '."\n";
	print GNUPLOT 'set yrange [ '.($minTemp-2).' : '.($maxTemp+2).' ]'."\n";
	print GNUPLOT 'set ytics out mirror 2'."\n";
	print GNUPLOT 'set ylabel "Grad Celsius"'."\n";
	print GNUPLOT 'set y2range [ '.($minTemp-2).' : '.($maxTemp+2).' ]'."\n";
	print GNUPLOT 'set y2tics out mirror 2'."\n";
	print GNUPLOT 'set y2label "Grad Celsius"'."\n";
	print GNUPLOT 'set mxtics 4'."\n";
	print GNUPLOT 'set mytics 2'."\n";
	print GNUPLOT 'set grid x y'."\n";
	print GNUPLOT 'set xlabel "Datum und Uhrzeit"'."\n";
	print GNUPLOT 'set title " '.$sensorName.'"'."\n";
	print GNUPLOT 'set output "'.$pngFilename.'"'."\n";
	print GNUPLOT 'set style fill solid border -1'."\n";
	print GNUPLOT 'set style line 1 lt 2 lw 1'."\n";
	print GNUPLOT 'set pointsize .5'."\n";
	print GNUPLOT 'set sample 45'."\n";
	print GNUPLOT 'set terminal png size 1024,400'."\n";
	print GNUPLOT 'set terminal png'."\n";
	print GNUPLOT 'plot "'.$csvFilename.'" using 1:2 title "'.$sensorName.'"  with lines'."\n";
	
	close GNUPLOT;
	
	#---------------------------------------------------------------------
	#3. run gnuplot and copy png image to www directory and change rights	
	#---------------------------------------------------------------------
	system ("gnuplot $gnuplotFilename");
	system ("chown www-data:www-data $pngFilename && cp $pngFilename /var/www/img/" );
	

	#---------------------------------------------------------
	print "'$sensorName' :$numEntries csv entries, gnuplottet $gnuplotFilename into $pngFilename.\n";

}

print "Finished writing $sensorCount gnuplotFiles with data\n";


1;
