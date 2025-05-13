<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include 'config.php'; // Include your database connection

// Read JSON input
$inputData = json_decode(file_get_contents("php://input"), true);

if (!isset($inputData['Uname'], $inputData['Email'], $inputData['Pword'], $inputData['Emp_No'], $inputData['Utype'])) {
    echo json_encode(["status" => "error", "message" => "Missing required fields"]);
    exit;
}

$uname = trim($inputData['Uname']);
$email = trim($inputData['Email']); // Corrected
$pword = trim($inputData['Pword']);
$empNo = trim($inputData['Emp_No']);
$utype = trim($inputData['Utype']);

// Hash the password before storing
$hashedPassword = password_hash($pword, PASSWORD_BCRYPT);

// Check if username already exists
$stmt = $conn->prepare("SELECT Uname FROM user_id WHERE Uname = ?");
$stmt->bind_param("s", $uname);
$stmt->execute();
$stmt->store_result();
if ($stmt->num_rows > 0) {
    echo json_encode(["status" => "error", "message" => "Username already exists"]);
    exit;
}

// Insert user into database
$stmt = $conn->prepare("INSERT INTO user_id (Uname, Email, Pword, Emp_No, Utype) VALUES (?, ?, ?, ?, ?)");
$stmt->bind_param("sssss", $uname, $email, $hashedPassword, $empNo, $utype);
if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Registration successful"]);
} else {
    echo json_encode(["status" => "error", "message" => "Failed to register"]);
}

$stmt->close();
$conn->close();
?>
