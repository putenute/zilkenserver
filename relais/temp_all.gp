set datafile separator ","
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%d/%h%H:%M"
set xrange [ "2013-12-26 21:46:40" : "2013-12-26 21:58:38" ]
#set autoscale y 
set yrange [ 13.69 : 42 ]
set ytics out mirror 2
set ylabel "Grad Celsius"
set y2range [ 13.69 : 42 ]
set y2tics out mirror 2
set y2label "Grad Celsius"
set mxtics 4
set mytics 2
set grid x y
set xlabel "Datum und Uhrzeit"
set title "Alle Temperatur-Sensoren"
set output "temp_all.png"
set style fill solid border -1
set style line 1 lt 2 lw 1
set pointsize .2
set sample 45
set terminal png size 1024,600
set terminal png
plot "temp_all.dat" using 1:2 title "USB-Sensor 2D "  with lines, "temp_all.dat" using 1:3 title "USB-Sensor 63"  with lines, "temp_all.dat" using 1:4 title "USB-Sensor 3A "  with lines, "temp_all.dat" using 1:5 title "Serverschrank"  with lines, "temp_all.dat" using 1:6 title "Bettakomben Raum"  with lines, 
