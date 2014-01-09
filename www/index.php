<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="bootstrap/docs-assets/ico/favicon.png">

    <title>Zilkens Bettakomben-Webseite</title>

    <!-- Bootstrap core CSS -->
    <link href="bootstrap/dist/css/bootstrap.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->

    <!-- Custom styles for this template -->
    <link href="carousel.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-latest.js"></script> 
<script type="text/javascript" src="/js/jquery.tablesorter.js"></script> 

  </head>
<!-- NAVBAR
================================================== -->
  <body>
    <div class="navbar-wrapper">
      <div class="container">

        <div class="navbar navbar-inverse navbar-static-top" role="navigation">
          <div class="container">
            <div class="navbar-header">
              <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
              </button>
              <a class="navbar-brand" href="#">Bettakomben</a>
            </div>
            <div class="navbar-collapse collapse">
              <ul class="nav navbar-nav">
                <li class="active"><a href="/">Startseite</a></li>
                <li><a href="#about">Impressum</a></li>
                <li><a href="#contact">Kontakt</a></li>
<!--                <li class="dropdown">
                  <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
                  <ul class="dropdown-menu">
                    <li><a href="#">Action</a></li>
                    <li><a href="#">Another action</a></li>
                    <li><a href="#">Something else here</a></li>
                    <li class="divider"></li>
                    <li class="dropdown-header">Nav header</li>
                    <li><a href="#">Separated link</a></li>
                    <li><a href="#">One more separated link</a></li>
                  </ul>
              </li>
-->
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>


<div class="row">
<div class="col-lg-4">
<br><br><br><br>



<h3>Heizung f&uuml;r Wasserwechsel-Tonne </h3>

<?php

if(isset($_POST['1_on'])){
$state = exec("python /var/www/relais/drcontrol.py -d DAE000OP -r1 -c on");
} 

if(isset($_POST['1_off'])){
$state = exec("python /var/www/relais/drcontrol.py -d DAE000OP -r1 -c off");
} 



$state = exec("python /var/www/relais/drcontrol.py -d DAE000OP -r1 -c state");

if ( $state == "OFF") 
{
  echo "Wassertonnen-Heizung ist aus. \n";
  echo '<form action="" method="post">';
  echo '  <button class="heizungsbutton" type="submit" name="1_on">Heizung anschalten</button>';
  echo '</form> ';

 
}
elseif ( $state == "ON")
 {
  echo "Wassertonnen-Heizung ist an. \n";
  echo '<form action="" method="post">';
  echo '  <button class="heizungsbutton" type="submit" name="1_off">Heizung ausschalten</button>';
  echo '</form> ';
  }
else
  {
  echo "UNBEKANTER FEHLER:  $state \n";
  }


?>

<h3>Aktueller Stromverbrauch in den Bettakomben</h3>
<a href="#"><img src="img/snap.jpg" border="5" alt="BILD"></a>Watt


<h3>Aktuelle Temperaturen aus den Bettakomben</h3>

<?php
$con=mysqli_connect("localhost","dt_logger","lololo","digitemp");
// Check connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

// echo '<table border="1" cellspacing="1" class="tablesorter" >';
 echo '<table border="1" >';
echo '<thead>';
echo '<tr>';
echo '<th>Sensor</th>';
echo '<th>Temperatur</th>';
echo '<th>Letzte Messung</th>';
echo '</tr>';
echo '</thead>';

$result = mysqli_query($con,"SELECT * FROM sensors order by name asc");

while($row = mysqli_fetch_array($result))
  {
	$lasttime= "";
 	$lasttemp="";
	$serial = $row['serial'];
	$name =$row['name'];
	$result2 = mysqli_query($con,'SELECT * FROM digitemp where SerialNumber = "'.$serial.'" order by time desc limit 1');
	while($row2 = mysqli_fetch_array($result2))
	{
	  $lasttime=  $row2['time'];
 	  $lasttemp= $row2['Temp'];
		
	}


       echo '<tr>';
        echo '<td> '.$name.'</td>';
       echo '<td> '.$lasttemp.' &deg;C</td>';
       echo '<td> '.$lasttime.'</td>';
      echo '</tr>';
  }
  echo '</table>';

mysqli_close($con);
?>

<script type="text/javascript">
$(document).ready(function() { 
    // call the tablesorter plugin 
    $("table").tablesorter({ 
        // sort on the first column and third column, order asc 
        sortList: [[0,0],[2,0]] 
    }); 
 }); 
 </script>

<a href="#"><img src="img/temp_all.png" border="1" alt="BILD"></a>



<a name="1" href="#"><img src="img/temp1.png" border="1" alt="BILD1"></a>
<a href="#"><img src="img/temp2.png" border="1" alt="BILD2"></a>
<a href="#"><img src="img/temp3.png" border="1" alt="BILD3"></a>
<a href="#"><img src="img/temp4.png" border="1" alt="BILD4"></a>
<a href="#"><img src="img/temp5.png" border="1" alt="BILD5"></a>
<a href="#"><img src="img/temp6.png" border="1" alt="BILD6"></a>
<a href="#"><img src="img/temp7.png" border="1" alt="BILD7"></a>
<a href="#"><img src="img/temp8.png" border="1" alt="BILD8"></a>
<a href="#"><img src="img/temp9.png" border="1" alt="BILD9"></a>
<a href="#"><img src="img/temp10.png" border="1" alt="BILD10"></a>
<a href="#"><img src="img/temp11.png" border="1" alt="BILD11"></a>
<a href="#"><img src="img/temp12.png" border="1" alt="BILD12"></a>




</div>
</div>


      <!-- FOOTER -->
      <footer>
        <p class="pull-right"><a href="#">Zur&uuml;ck nach oben</a></p>
        <p>Zilkenserver &middot; <a href="#">Datenschutz</a> &middot; <a href="#">Impressum</a></p>
      </footer>

    </div><!-- /.container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
    <script src="bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="bootstrap/docs-assets/js/holder.js"></script>
  </body>
</html>
