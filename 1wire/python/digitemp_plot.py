#!/usr/local/bin/python
#
# this will extract the relevant temperature data from the DB and plot the data via gnuPlot into a png graph

# This has been updated to suit the new MySQL table that hosts one record for all the sensors
#
#  Parkview 2013-04-05
#

import os
import time
import MySQLdb as mdb
import sys
import subprocess
import datetime, time
import ephem # install from pyephem`

Data_Limit=360
MYSQL_HOST = 'localhost'
MYSQL_DB = "temperature"
MYSQL_USER = "dt_logger"
MYSQL_PASSWD = "lololo"
MYSQL_TBL_SENSOR = "sensors"
MYSQL_TBL_TEMP = "digitemp"
file="/tmp/gnuplot-data.dat"
max_file="/tmp/gnuplot-data-max.dat"
min_file="/tmp/gnuplot-data-min.dat"
srise_file="/tmp/gnuplot-data-srise.dat"
sset_file="/tmp/gnuplot-data-sset.dat"

# lets work out the previous Sun Set and Sun Rise:
o = ephem.Observer()
o.lat, o.long, o.date = '-33:65', '115:39', datetime.datetime.utcnow()
sun = ephem.Sun(o)
SRISE=ephem.localtime(o.previous_rising(sun))
SSET=ephem.localtime(o.previous_setting(sun))

#  First need to query the DB for a list of sensor names and compare with what we actually have on the network
try:
    con = mdb.connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWD, MYSQL_DB);
    cur = con.cursor()
    # go get around days worth of temperature records
    cur.execute("""SELECT datetime,Sensor1,Sensor2,Sensor3,Sensor4,Sensor5,Sensor6,Sensor7,Sensor8,Sensor9,Sensor10,11,Sensor12,Sensor13,Sensor14,Sensor15,Sensor16,Sensor17,Sensor18,Sensor19,Sensor20,Sensor21,Sensor22,Sensor23 FROM temp_5min_tbl  order by datetime desc limit %s""", Data_Limit)
    f=open(file, 'w')
    for row in cur.fetchall():
       # now lets  add this into a list variable for use
       DATA1=row[0].strftime('%Y-%m-%d %H:%M:%S'),str(row[8]),str(row[9]),str(row[10]),str(row[12]),str(row[16]),str(row[17])
       DATA=','.join(DATA1)+'\n'
       f.write(DATA)
       print  DATA  # could add a strip RH to clear the line feed
    print " "
    f.close()
    # now lets get the min data so it can be plotted
    cur.execute("""SELECT datetime,temp FROM temperature.newlastDayTemperature order by temp asc limit 1;""")
    f=open(min_file, 'w')
    for row in cur.fetchall():
       # now lets  add this into a list variable for use
       DATA1=row[0].strftime('%Y-%m-%d %H:%M:%S'),str(row[1])
       DATA=','.join(DATA1)+'\n'
       f.write(DATA)
    # now lets get the max data so it can be plotted
    cur.execute("""SELECT datetime,temp FROM temperature.newlastDayTemperature order by temp desc limit 1;""")
    f=open(max_file, 'w')
    for row in cur.fetchall():
       # now lets  add this into a list variable for use
       DATA1=row[0].strftime('%Y-%m-%d %H:%M:%S'),str(row[1])
       DATA=','.join(DATA1)+'\n'
       f.write(DATA)
       print  DATA  # could add a strip RH to clear the line feed
    print " "
    # now lets get the Sun Rise data so it can be plotted
    cur.execute("""SELECT datetime,Sensor17 FROM temperature.temp_5min_tbl where datetime > %s order by datetime asc limit 1;""", SRISE)
    f=open(srise_file, 'w')
    for row in cur.fetchall():
       # now lets  add this into a list variable for use
       DATA1=row[0].strftime('%Y-%m-%d %H:%M:%S'),str(row[1])
       DATA=','.join(DATA1)+'\n'
       f.write(DATA)
       print  DATA  # could add a strip RH to clear the line feed
    print " "
    # now lets get the Sun Set data so it can be plotted
    cur.execute("""SELECT datetime,temp FROM temperature.newlastDayTemperature where datetime > %s order by datetime asc limit 1;""", SSET)
    f=open(sset_file, 'w')
    for row in cur.fetchall():
       # now lets  add this into a list variable for use
       DATA1=row[0].strftime('%Y-%m-%d %H:%M:%S'),str(row[1])
       DATA=','.join(DATA1)+'\n'
       f.write(DATA)
       print  DATA  # could add a strip RH to clear the line feed
    print " "
   # print  "Data count: ", cur.count
    f.close()        
except mdb.Error, e:
    print "Error %d: %s" % (e.args[0],e.args[1])
    sys.exit(1)        
finally: 
    if con:     
      con.close()

# call the various gnuPlot scripts from here:
    try:
      subprocess.Popen('/usr/local/bin/RPi-Temperature/new_gnuplot_temperature_inside.sh',shell = True)  
    except OSError, e:
      print 'OS Error: '
    except subprocess.CalledProcessError, e:
      print cmd_output," - "
    try:
      subprocess.Popen('/usr/local/bin/RPi-Temperature/new_gnuplot_temperature_outside.sh',shell = True)
   except OSError, e:
      print 'OS Error: '
    except subprocess.CalledProcessError, e:
      print cmd_output," - "

#print " Sun Rise: ", SRISE
#print " Sun Set: ", SSET

