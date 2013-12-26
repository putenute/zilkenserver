set datafile separator ","
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%d %h%H:%M"
set xrange [ "2013-12-19 20:55:04" : "2013-12-25 11:05:14" ]
#set autoscale y 
set yrange [ 16.56 : 27.62 ]
set ytics out mirror 2
set ylabel "Grad Celsius"
set y2range [ 16.56 : 27.62 ]
set y2tics out mirror 2
set y2label "Grad Celsius"
set mxtics 4
set mytics 2
set grid x y
set xlabel "Datum und Uhrzeit"
set title " Glas links auf Heizmatte (USB2)"
set output "temp1.png"
set style fill solid border -1
set style line 1 lt 2 lw 1
set pointsize .5
set sample 45
set terminal png size 1024,400
set terminal png
plot "temp1.dat" using 1:2 title "Glas links auf Heizmatte (USB2)"  with lines
