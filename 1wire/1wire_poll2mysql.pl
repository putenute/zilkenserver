#!/usr/bin/perl -W

# DigiTemp MySQL logging script
# Copyright 2002 by Brian C. Lane <bcl@brianlane.com>
# All Rights Reserved
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA
#
# -------------------------[ HISTORY ]-------------------------------------
# 01/08/2004  The storage definition should have been decimal(6,2) instead
# bcl         of decimal(3,2). 
#             See http://www.mysql.com/doc/en/Numeric_types.html for a 
#             good description of how decimal(a,b) works.
#
# 08/18/2002  Putting together this MySQL logging script for the new 
# bcl         release of DigiTemp.
#
# -------------------------------------------------------------------------
# CREATE table digitemp (
#   dtKey int(11) NOT NULL auto_increment,
#   time timestamp NOT NULL,
#   SerialNumber varchar(17) NOT NULL,
#   Fahrenheit decimal(6,2) NOT NULL,
#   PRIMARY KEY (dtKey),
#   KEY serial_key (SerialNumber),
#   KEY time_key (time)
# );
#
# GRANT SELECT,INSERT ON digitemp.* TO dt_logger@localhost
# IDENTIFIED BY 'TopSekRet';
#
# -------------------------------------------------------------------------
use DBI;
use LWP::Simple;
use JSON qw( decode_json ); 


# Database info
my $db_name     = "digitemp";
my $db_user     = "dt_logger";
my $db_pass     = "lololo";

# The DigiTemp Configuration file to use
my $digitemp_rcfile = "/var/1wire/digitemp.cfg";
my $digitemp_binary = "/usr/bin/digitemp_DS9097U";


my $debug = 1;

# Connect to the database
my $dbh = DBI->connect("dbi:mysql:$db_name","$db_user","$db_pass")
          or die "I cannot connect to dbi:mysql:$db_name as $db_user - $DBI::errstr\n";



# Gather information from DigiTemp
# Read the output from digitemp
# Output in form SerialNumber<SPACE>Temperature in Fahrenheit

open( DIGITEMP, "digitemp_DS9097U -vv -i -c digitemp.conf -s /dev/ttyUSB0 && digitemp_DS9097U -c digitemp.conf -a -q USB  -o\"%R %.2C\" |");

while( <DIGITEMP> )
{
  print "$_\n" if($debug);
  chomp;

  ($serialnumber,$temperature) = split(/ /);

  if ($serialnumber !~ /^[0123456789abcdefABCDEF]+$/){
    print "$serialnumber is not a hex!\n" if($debug);
    next;
  }
  if ($temperature !~ /^[\d]+\.[\d]+$/){
    print "$temperature is not a temp!\n"if($debug);
    next;
  }

  my $isActive;
  print "NOW: $serialnumber\n";
  my $ssql = "SELECT * from sensors where serial='".$serialnumber."'";
  my $query = $dbh->prepare($ssql);
  $query->execute() or die $query->err_str;
  while (my $res = $query->fetchrow_hashref() ) {
    $isActive = "1" if $res->{isActive} eq "1";

  }
  if(!defined($isActive)){
    print "Sensor $serialnumber: NOT active\n";

  }else{

    my $sql="INSERT INTO digitemp SET SerialNumber='$serialnumber',temp=$temperature";
    print "SQL: $sql\n" if($debug);
    $dbh->do($sql) or die "Can't execute statement $sql because: $DBI::errstr";
  }
}

close( DIGITEMP );

############################
#get outside temp using openwaeather api
my $temp ="";
my $hum ="";
my $url = "http://api.openweathermap.org/data/2.5/weather?q=cologne,germany&units=metric";
my $json = get($url);
die "Can't GET $url" if (! defined $json);
my $decoded_json = decode_json( $json );

$temp = $decoded_json->{main}->{temp};
$hum = $decoded_json->{main}->{humidity};

if ($temp ne ""){
  my $sql="INSERT INTO digitemp SET SerialNumber='openweatherAPI',temp=$temp";
  print "temp SQL: $sql\n" if($debug);
  $dbh->do($sql) or die "Can't execute statement $sql because: $DBI::errstr";

}

$dbh->disconnect;

system ("chmod a+rw  /dev/bus/usb/005/*");
