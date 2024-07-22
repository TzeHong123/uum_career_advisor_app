<?php
$servername = "localhost";
$username   = "username here";
$password   = "pw here";
$dbname     = "db name here";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}else{
}
?>
