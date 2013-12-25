set datafile separator ","
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x auto
set xrange [ "2013-12-08 12:45:58" : "2013-12-20 12:25:09" ]
#set autoscale y 
set yrange [ -7 : 42 ]
set ytics out mirror 2
set ylabel "Grad Celsius"
set y2range [ -7 : 42 ]
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
plot "temp_all.dat" using 1:2 title "Aquarium Aussenscheibe"  with lines, "temp_all.dat" using 1:3 title "Glas links auf Heizmatte (USB2)"  with lines, "temp_all.dat" using 1:4 title "Glas rechts auf Heizmatte (USB3)"  with lines, "temp_all.dat" using 1:5 title "Pott auf Kabel (USB1)"  with lines, "temp_all.dat" using 1:6 title "Serverschrank"  with lines, "temp_all.dat" using 1:7 title "Bettakomben Raumtemperatur"  with lines, "temp_all.dat" using 1:8 title "Aussentemperatur"  with lines, 
