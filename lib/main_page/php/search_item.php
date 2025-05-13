<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'config.php'; // Include your existing database connection

if (isset($_GET["item_no"])) {
    $item_no = $conn->real_escape_string($_GET["item_no"]);
    $sql = "SELECT Item_Desc FROM inventory WHERE Item_No = '$item_no'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        echo json_encode(["Item_Desc" => $row["Item_Desc"]]);
    } else {
        echo json_encode(["error" => "Item not found"]);
    }
} else {
    echo json_encode(["error" => "No Item_No provided"]);
}

$conn->close();
?>
