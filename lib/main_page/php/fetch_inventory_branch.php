<?php
// Allow CORS and set content type
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include("config.php");

// Enable error reporting for development
error_reporting(E_ALL);
ini_set('display_errors', 1);

// this is the main branch count where it can only be changed through the database or the ERP
function fetchBranchInventory($conn) {
    $query = "SELECT Item_No, Bra_No, Bra_Qty FROM inventory_branch";
    $stmt = $conn->prepare($query);

    if (!$stmt) {
        echo json_encode(["status" => "error", "message" => "Failed to prepare SQL statement"]);
        return;
    }

    if (!$stmt->execute()) {
        echo json_encode(["status" => "error", "message" => "Failed to execute query"]);
        return;
    }

    $stmt->bind_result($itemNo, $branchNo, $quantity);
    $data = [];

    while ($stmt->fetch()) {
        if (!isset($data[$itemNo])) {
            $data[$itemNo] = [];
        }
        $data[$itemNo][$branchNo] = (int)$quantity;
    }

    $stmt->close();

    echo json_encode([
        "status" => "success",
        "data" => $data
    ]);
}

fetchBranchInventory($conn);
?>
