#/bin/perl -e

use strict;
use warnings;
use Math::Round;
use Data::Dumper;

use DBI;
# Database info
my $db_name     = "digitemp";
my $db_user     = "dt_logger";
my $db_pass     = "lololo";



my $login = `curl -s -d "pw=lololo" http://192.168.2.166/login.html`;

my $voltage=-1;
my $current=-1;
my $power=-1;
my $energy=-1;



if( $login =~ /(mac=\ "C2426B4DDCE2")/i ){
  
  # Current	1.51	A	current = I /100;
  if($login    =~ /var\ I\ \ =\ (\d+)/i){
    $current = nearest(0.01, $1/100);
  }
  

  #Voltage	221.0	V	voltage = V / 10;
  if($login    =~/var\ V\ \ =\ (\d+)/i){
    $voltage = nearest(0.1,$1/10);
  }

  #var P=197038;
  if($login    =~/var\ P=(\d+)/i){
    $power = nearest(1,$1/466);
  }

  #Energy	112.0	kWh	energy  = E/25600';
  if($login    =~/var\ P=(\d+)/i){
    $energy = nearest(0.1,$1/25600);
  }
  print  $power."W ".$voltage."V ".$current."A ".$energy."kWh"."\n";

  #INSERT INTO DB NOW

  # Connect to the database
  my $dbh = DBI->connect("dbi:mysql:$db_name","$db_user","$db_pass")
          or die "I cannot connect to dbi:mysql:$db_name as $db_user - $DBI::errstr\n";

  #| stromding | CREATE TABLE `stromding` (
  #`id` int(11) NOT NULL AUTO_INCREMENT,
  #`name` varchar(255) NOT NULL,
  #`time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  #`power` float NOT NULL,
  #`voltage` float NOT NULL,
  #`current` float NOT NULL,
  #`energy` float NOT NULL,
  #PRIMARY KEY (`id`)
  #) ENGINE=InnoDB DEFAULT CHARSET=utf8 |


  my $sql="INSERT INTO stromding SET name='Bettakomben',power=$power,voltage=$voltage, current=$current,energy=$energy";
  #print "SQL: $sql\n" if($debug);
  $dbh->do($sql) or die "Can't execute statement $sql because: $DBI::errstr";


  $dbh->disconnect;





}else {
  die "Error during energenie login; ".Dumper($login);

}


my $logout = `curl -s  http://192.168.2.166/login.html`;


if( $logout =~ /(name="lForm"><div>&nbsp;EnerGenie Web:&nbsp;putenute)/i ){
  #print "Logout successfull. \n";

}else {
  die "Error during energenie logout; ".Dumper($logout);

}



1;
