Sobald neue sensoren angeschlossen wurden:
Immer chmod a+rw /dev/ttyUSB0

Erst
digitemp_DS9097U -vv -i -c digitemp.conf -s /dev/ttyUSB0

danach eine Auslese machen mit  
digitemp_DS9097U -c digitemp.conf -a -q USB



