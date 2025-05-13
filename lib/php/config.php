<?php
$host = "localhost";
$user = "root";  // Default XAMPP user
$password = "root";  // Default is empty
$database = "a1prime_db";  // Change to your database name

$conn = new mysqli("localhost", "root", "", "a1prime_db");


if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
