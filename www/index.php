!<DOCTYPE html>
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

<a name="top"></a> 

<h3> Inhaltsverzeichnis</h3>
<br>
<a href="#heat"><h4>Zur Heizung f&uuml;r Wasserwechsel-Tonne</h4></a>
<a href="#strom"><h4>Zum Stromverbrauch<h4></a>
<a href="#temp"><h4>Zu den aktuellen Temperaturen</h4></a>
<a href="#webcam"><h4>Zu den Webcams</h4></a>

<hr>
<br><br><br><br>


<a name="heat"></a>
<h3 >Heizung f&uuml;r Wasserwechsel-Tonne </h3>

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
<a href="#top">Zur&uuml;ck nach oben</a>
<br><br>

<a name="strom"></a>
<h3>Aktueller Stromverbrauch in den Bettakomben</h3>
<!-- <a href="#"><img src="img/stromding.jpg" border="5" alt="BILD"></a>Watt -->
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
echo '<th>Stromverbrauch </th>';
echo '<th>Letzte Messung</th>';
echo '<th>Strommessger&auml;t</th>';
echo '</tr>';
echo '</thead>';

$result = mysqli_query($con,"SELECT name, watt, time FROM stromding order by time desc limit 1");

while($row = mysqli_fetch_array($result))
  {
       echo '<tr>';
       echo '<td> '.$row['watt'].' W </td>';
       echo '<td> '.$row['time'].' </td>';
       echo '<td> <a href="img/stromding.jpg">Bild</a> </td>';
      echo '</tr>';
  }
  echo '</table>';

mysqli_close($con);
?>
<a href="#"><img src="img/stromding.png" border="1" alt="BILD"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<br><br>


<a name="temp"></a>
<h3 >Aktuelle Temperaturen aus den Bettakomben</h3>

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
        echo '<td><a href="#'.$serial.'">'.$name.'</a></td>';
       echo '<td> '.$lasttemp.' &deg;C</td>';
       echo '<td> '.$lasttime.'</td>';
      echo '</tr>';
  }
  echo '</table>';

mysqli_close($con);
?>
<a href="#top">Zur&uuml;ck nach oben</a>


<a name="28161927050000BB" href="#"><img src="img/28161927050000BB.png" border="1" alt "Temperaturbild"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="2866B512050000F8" href="#"><img src="img/2866B512050000F8.png" border="1" alt "Temperaturbild"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="28A7ACEF04000098" href="#"><img src="img/28A7ACEF04000098.png" border="1" alt "Temperaturbild"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="28C4A027050000AD" href="#"><img src="img/28C4A027050000AD.png" border="1" alt "Temperaturbild"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="28170C2705000022" href="#"><img src="img/28170C2705000022.png" border="1" alt "Temperaturbild"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="287AA2270500003A" href="#"><img src="img/287AA2270500003A.png" border="1" alt "Temperaturbild"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="28A8BC88040000D6" href="#"><img src="img/28A8BC88040000D6.png" border="1" alt "Temperaturbild"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="28CFA8EE0400006A" href="#"><img src="img/28CFA8EE0400006A.png" border="1" alt "Temperaturbild"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="284029EF0400002D" href="#"><img src="img/284029EF0400002D.png" border="1" alt "Temperaturbild"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="287EA6EE040000F8" href="#"><img src="img/287EA6EE040000F8.png" border="1" alt "Temperaturbild"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="284174EF04000063" href="#"><img src="img/284174EF04000063.png" border="1" alt "Temperaturbild"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="28C4728704000072" href="#"><img src="img/28C4728704000072.png" border="1" alt "Temperaturbild"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="openweatherAPI" href="#"><img src="img/openweatherAPI.png" border="1" alt "Temperaturbild"></a>

<br><br>

<a name="webcam"></a>
<h3 >Webcam-Bilder aus den Battakomben</h3>
<a name="webcam1" href="#"><img src="img/webcam1.jpg" border="1" alt "Webcam 1"></a>
<a href="#top">Zur&uuml;ck nach oben</a>
<a name="webcam2" href="#"><img src="img/webcam2.jpg" border="1" alt "Webcam 2"></a>
<a href="#top">Zur&uuml;ck nach oben</a>

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
