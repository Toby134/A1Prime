<?php
session_start();

// Allow CORS (important if testing from emulator or mobile)
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Destroy the session
session_destroy();

// Send JSON response
echo json_encode(["status" => "success", "message" => "Logged out successfully"]);
?>
