<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include 'config.php'; // Database connection

// Extract the token from the Authorization header
$headers = getallheaders();
if (!isset($headers['Authorization'])) {
    echo json_encode(["status" => "error", "message" => "No authentication token provided"]);
    exit;
}

$token = str_replace("Bearer ", "", $headers['Authorization']); // Remove "Bearer " prefix

// Validate the token
$stmt = $conn->prepare("SELECT ID, Uname, email, Emp_No, Utype, Last_Pass, IsWhatsNew FROM user_id WHERE token = ?");
$stmt->bind_param("s", $token);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 1) {
    $user = $result->fetch_assoc();
    echo json_encode([
        "status" => "success",
        "user" => [
            "id" => $user['ID'],
            "username" => $user['Uname'],
            "email" => $user['email'],
            "emp_no" => $user['Emp_No'],
            "user_type" => $user['Utype'],
            "last_password_change" => $user['Last_Pass'],
            "is_whats_new" => $user['IsWhatsNew']
        ]
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Invalid token"]);
}

$stmt->close();
$conn->close();
?>
