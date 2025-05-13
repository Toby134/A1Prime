<?php
// Allow CORS
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Include the database connection
include("config.php");

// Function to fetch all inventory counts
function fetch_all_inventory_counts() {
    global $conn;

    // Prepare the SQL query to select all items from the inventory_count table
    $stmt = $conn->prepare("SELECT Item_No, Bra_No, Count FROM inventory_count");
    if ($stmt === false) {
        return json_encode(['error' => 'Failed to prepare SQL statement']);
    }

    // Execute the query
    if (!$stmt->execute()) {
        return json_encode(['error' => 'Failed to execute query']);
    }

    // Bind the result
    $stmt->bind_result($item_no, $branch, $count);

    // Initialize an array to store the results
    $inventory_counts = [];

    // Fetch all results
    while ($stmt->fetch()) {
        $inventory_counts[] = [
            'Item_No' => $item_no,
            'Bra_No' => $branch,
            'Count' => $count
        ];
    }

    // Return the results as a JSON object
    return json_encode(['inventory_counts' => $inventory_counts]);
}

// Fetch all inventory counts
$response = fetch_all_inventory_counts();
echo $response;
?>
