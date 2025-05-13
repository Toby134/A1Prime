<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include("config.php");

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Define the SQL query
$sql = "SELECT 
            Item_No, 
            Item_Desc, 
            Item_Price, 
            Qty, 
            Barcode, 
            Brand, 
            Model, 
            Cost, 
            Unit_Meas, 
            Color, 
            Size, 
            Weight, 
            Weight_Unit, 
            Spec_Feat, 
            Location, 
            Upcode, 
            Serialized, 
            Assembly, 
            Taxable, 
            Last_Inv_Date, 
            Freight_Cost, 
            Last_Order_Date, 
            Expect_Del, 
            Qty_Last_Order, 
            ReOrder_Pt, 
            Last_Cost_Supp, 
            Min_Price, 
            Max_Price, 
            Qty_Order, 
            Warranty, 
            Active, 
            LastDate_Update, 
            IsBoutique, 
            IsFixAsset, 
            IsRegularItem, 
            IsAssetItem, 
            IsTechnoCardRedeem, 
            Cat_No_Asset, 
            IsReprice, 
            IsOrder, 
            IsLoadSIM, 
            IsPrintWarranty, 
            Item_Pix_Filename, 
            Item_Pix2_Filename, 
            Item_Icon, 
            ItemTempID, 
            ReferRebatePercent, 
            CreatedBy, 
            DateCreated, 
            ModifiedBy, 
            DateModified, 
            BullGuardPromo, 
            IsPackage 
        FROM inventory";  // Added Barcode to the query

// Prepare the statement
$stmt = $conn->prepare($sql);
if (!$stmt) {
    echo json_encode(["status" => "error", "message" => "SQL Error: " . $conn->error]);
    exit;
}

// Execute the query
$stmt->execute();
$result = $stmt->get_result();

// Fetch all items
$items = $result->fetch_all(MYSQLI_ASSOC);

// Close the statement and connection
$stmt->close();
$conn->close(); 

// Return JSON response
if (!empty($items)) {
    echo json_encode(["status" => "success", "message" => "Items fetched successfully", "data" => $items]);
} else {
    echo json_encode(["status" => "error", "message" => "No items found", "data" => []]);
}
?>
