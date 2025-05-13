<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

include 'config.php'; // Ensure database connection is correct

// Read JSON input
$inputData = json_decode(file_get_contents("php://input"), true);

if (!isset($inputData['Uname'], $inputData['Pword'])) {
    echo json_encode(["status" => "error", "message" => "Missing username or password"]);
    exit;
}

$uname = trim($inputData['Uname']);
$pword = trim($inputData['Pword']);

// Fetch the stored hashed password from the database
$stmt = $conn->prepare("SELECT Pword FROM user_id WHERE Uname = ?");
$stmt->bind_param("s", $uname);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows === 1) {
    $stmt->bind_result($hashedPassword);
    $stmt->fetch();

    // Debugging output (REMOVE in production)
    error_log("Stored Hash: " . $hashedPassword);
    error_log("Entered Password: " . $pword);

    // Verify password
    if (password_verify($pword, $hashedPassword)) {
        echo json_encode(["status" => "success", "message" => "Login successful"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Incorrect password"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "User not found"]);
}

$stmt->close();
$conn->close();
?>
