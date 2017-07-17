<?php

$dbhost = "localhost";
$dbuser = "root";
$dbpass = "root";
$dbname = "CollegeFeed";

try{
	$conn = new PDO("mysql:host=$dbhost;dbname=$dbname;", $dbuser, $dbpass);
} catch(PDOException $e){
	die("Connection Failed: ". $e->getMessage());
}

?>