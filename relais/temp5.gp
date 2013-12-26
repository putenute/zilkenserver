set datafile separator ","
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%d %h%H:%M"
set xrange [ "2013-12-26 21:46:41" : "2013-12-26 21:58:34" ]
#set autoscale y 
set yrange [ 13.69 : 17.69 ]
set ytics out mirror 2
set ylabel "Grad Celsius"
set y2range [ 13.69 : 17.69 ]
set y2tics out mirror 2
set y2label "Grad Celsius"
set mxtics 4
set mytics 2
set grid x y
set xlabel "Datum und Uhrzeit"
set title " Serverschrank"
set output "temp5.png"
set style fill solid border -1
set style line 1 lt 2 lw 1
set pointsize .5
set sample 45
set terminal png size 1024,400
set terminal png
plot "temp5.dat" using 1:2 title "Serverschrank"  with lines
