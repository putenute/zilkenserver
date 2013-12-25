#Sobald neue sensoren angeschlossen wurden:


#chmod a+rw /dev/ttyUSB1

digitemp_DS9097U -vv -i -c digitemp.conf -s /dev/ttyUSB1


digitemp_DS9097U -c digitemp.conf -a -q USB



