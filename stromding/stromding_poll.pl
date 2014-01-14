#!/usr/bin/perl -W

use DBI;

# Database info
my $db_name     = "digitemp";
my $db_user     = "dt_logger";
my $db_pass     = "lololo";


my $debug = 1;

# Connect to the database
my $dbh = DBI->connect("dbi:mysql:$db_name","$db_user","$db_pass")
          or die "I cannot connect to dbi:mysql:$db_name as $db_user - $DBI::errstr\n";


my $cmdString = "fswebcam -r 640x480 -S 15 --jpeg 95 save /tmp/stromding.jpg -q";
$cmdString .= "&&  mogrify -crop 210x100+290+150 /tmp/stromding.jpg";
$cmdString .= "&& cp /tmp/stromding.jpg  /var/www/img/";
$cmdString .= "&& ssocr  grayscale --number-digits=3 /var/www/img/stromding.jpg |";


open( STROMDING, $cmdString);


while( <STROMDING> )
{
#  print "$_\n" if($debug);
  chomp;
  my $stromverbrauch = $_;
  print "stromverbrauch = $_\n";
 #stromding | CREATE TABLE `stromding` (
 # `id` int(11) NOT NULL AUTO_INCREMENT,
 # `name` varchar(255) NOT NULL,
 # `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 # `watt` int(11) NOT NULL,
 # PRIMARY KEY (`id`)

  my $sql="INSERT INTO stromding SET name='Bettakomben',watt=$stromverbrauch";
  print "SQL: $sql\n" if($debug);
  $dbh->do($sql) or die "Can't execute statement $sql because: $DBI::errstr";
}

close( STROMDING );

$dbh->disconnect;

