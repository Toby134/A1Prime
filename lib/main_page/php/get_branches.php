<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include("config.php");

$result = mysqli_query($conn, "SELECT Bra_No AS BranchID, Bra_Name AS BranchName FROM branch WHERE IsActive = '1' ORDER BY Bra_Name");

$branches = [];
while ($row = mysqli_fetch_assoc($result)) {
    $branches[] = $row;
}

echo json_encode($branches);
mysqli_close($conn);
?>
