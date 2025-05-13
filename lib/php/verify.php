<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include 'config.php';

if (!isset($_GET['token'])) {
    echo json_encode(["status" => "error", "message" => "Missing token"]);
    exit;
}

$token = $_GET['token'];

// Find user with matching token
$stmt = $conn->prepare("SELECT Uname FROM user_id WHERE verification_token = ?");
$stmt->bind_param("s", $token);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

if ($user) {
    // Mark user as verified
    $stmt = $conn->prepare("UPDATE user_id SET verified = 1, verification_token = NULL WHERE verification_token = ?");
    $stmt->bind_param("s", $token);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Email verified successfully!"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Verification failed."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Invalid token"]);
}

$stmt->close();
$conn->close();
?>
