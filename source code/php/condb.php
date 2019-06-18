<?php
	$servername="localhost";
	$username="listener";
	$password="listener.970918";
	$dbname="listener";
    $con=new mysqli($servername,$username,$password,$dbname);
	$program_char = "utf8" ;
	mysqli_set_charset( $con , $program_char );
?>