<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include("config.php");

$response = [];

// Ensure all required fields are present
if (!isset($_POST['item_no'], $_POST['bra_no'], $_POST['count'], $_POST['user'])) {
    echo json_encode(["error" => "Missing required fields"]);
    exit();
}

// Get and sanitize input values
$item_no = trim($_POST['item_no']);
$bra_name = trim($_POST['bra_no']);
$count = trim($_POST['count']);
$user = trim($_POST['user']);

// Debug: Log input values
error_log("Received Data: item_no=$item_no, bra_no=$bra_name, count=$count, user=$user");

// Fetch Bra_No using Bra_Name
$bra_query = $conn->prepare("SELECT Bra_No FROM branch WHERE Bra_Name = ?");
if (!$bra_query) {
    echo json_encode(["error" => "Prepare failed: " . $conn->error]);
    exit();
}
$bra_query->bind_param("s", $bra_name);
$bra_query->execute();
$bra_result = $bra_query->get_result();

if ($bra_result->num_rows > 0) {
    $bra_row = $bra_result->fetch_assoc();
    $bra_no = $bra_row['Bra_No'];

    // Debug: Confirm fetched Bra_No
    error_log("Fetched Bra_No: $bra_no");

    // Check if item exists in inventory_count
    $query = $conn->prepare("SELECT Count FROM inventory_count WHERE Item_No = ? AND Bra_No = ?");
    if (!$query) {
        echo json_encode(["error" => "Prepare failed: " . $conn->error]);
        exit();
    }
    $query->bind_param("ss", $item_no, $bra_no);
    $query->execute();
    $result = $query->get_result();

    if ($result->num_rows > 0) {
        // Fetch current count
        $row = $result->fetch_assoc();
        $current_count = $row['Count'];

        // Debug: Log existing count
        error_log("Existing Count: $current_count");

        // Update count (Add to existing count)
        $stmt = $conn->prepare("UPDATE inventory_count SET Count = Count + ?, CountUser = ? WHERE Item_No = ? AND Bra_No = ?");
        if (!$stmt) {
            echo json_encode(["error" => "Prepare failed: " . $conn->error]);
            exit();
        }
        $stmt->bind_param("ssss", $count, $user, $item_no, $bra_no);
        if (!$stmt->execute()) {
            echo json_encode(["error" => "Execution failed: " . $stmt->error]);
            exit();
        }

        // Fetch the latest count after update
        $stmt = $conn->prepare("SELECT Count FROM inventory_count WHERE Item_No = ? AND Bra_No = ?");
        $stmt->bind_param("ss", $item_no, $bra_no);
        $stmt->execute();
        $latest_count_result = $stmt->get_result();
        if ($latest_count_result->num_rows > 0) {
            $latest_count_row = $latest_count_result->fetch_assoc();
            $response["latest_count"] = $latest_count_row['Count'];
        }

        // Debug: Log update success
        error_log("Updated Count: New Count = " . ($current_count + $count));

        $response["message"] = "Update successful";
    } else {
        // Insert new item
        $stmt = $conn->prepare("INSERT INTO inventory_count (Item_No, Bra_No, Count, CountUser) VALUES (?, ?, ?, ?)");
        if (!$stmt) {
            echo json_encode(["error" => "Prepare failed: " . $conn->error]);
            exit();
        }
        $stmt->bind_param("ssss", $item_no, $bra_no, $count, $user);
        if (!$stmt->execute()) {
            echo json_encode(["error" => "Execution failed: " . $stmt->error]);
            exit();
        }

        // Fetch the latest count after insert
        $stmt = $conn->prepare("SELECT Count FROM inventory_count WHERE Item_No = ? AND Bra_No = ?");
        $stmt->bind_param("ss", $item_no, $bra_no);
        $stmt->execute();
        $latest_count_result = $stmt->get_result();
        if ($latest_count_result->num_rows > 0) {
            $latest_count_row = $latest_count_result->fetch_assoc();
            $response["latest_count"] = $latest_count_row['Count'];
        }

        // Debug: Log insert success
        error_log("Insert Successful: Item_No=$item_no, Bra_No=$bra_no, Count=$count");

        $response["message"] = "Insert successful";
    }

    // Close statements
    $stmt->close();
    $query->close();

    // Fetch total count of the item across all branches
    $total_count_query = $conn->prepare("SELECT SUM(Count) as TotalCount FROM inventory_count WHERE Item_No = ?");
    if (!$total_count_query) {
        echo json_encode(["error" => "Prepare failed: " . $conn->error]);
        exit();
    }
    $total_count_query->bind_param("s", $item_no);
    $total_count_query->execute();
    $total_count_result = $total_count_query->get_result();

    if ($total_count_result->num_rows > 0) {
        $total_count_row = $total_count_result->fetch_assoc();
        $response["total_count"] = $total_count_row['TotalCount'];
    }

    // Close total count statement
    $total_count_query->close();
} else {
    $response["error"] = "Branch not found";
}

// Close database connections
$bra_query->close();
$conn->close();

// Return response
echo json_encode($response);
?>
