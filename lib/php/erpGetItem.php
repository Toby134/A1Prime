<?php
// Allow CORS
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include("config.php");

// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Fetch inventory count, this count is where the user checks the invnetory then inputs the count. it does not go directly to the official branch count.
function fetch_inventory_counts($conn) {
    $stmt = $conn->prepare("SELECT Item_No, Bra_No, Count FROM inventory_count");
    if (!$stmt) return ['error' => 'Failed to prepare inventory count SQL statement'];
    if (!$stmt->execute()) return ['error' => 'Failed to execute inventory count query'];

    $stmt->bind_result($item_no, $bra_no, $count);
    $inventory_counts = [];

    while ($stmt->fetch()) {
        $item_no = (string)$item_no;
        $bra_no = (string)$bra_no;
        $inventory_counts[$item_no][$bra_no] = $count;
    }

    $stmt->close();
    return $inventory_counts;
}

// Fetch branch inventory
// function fetch_branch_inventory($conn) {
//     $stmt = $conn->prepare("SELECT Item_No, Bra_No, Bra_Qty FROM inventory_branch");
//     if (!$stmt) return ['error' => 'Failed to prepare branch inventory SQL statement'];
//     if (!$stmt->execute()) return ['error' => 'Failed to execute branch inventory query'];

//     $stmt->bind_result($item_no, $bra_no, $bra_qty);
//     $inventory_branches = [];

//     while ($stmt->fetch()) {
//         $item_no = (string)$item_no;
//         $bra_no = (string)$bra_no;
//         $inventory_branches[$item_no][$bra_no] = $bra_qty;
//     }

//     $stmt->close();
//     return $inventory_branches;
// }

// Main inventory query
$sql = "SELECT 
    Item_No, Item_Desc, Item_Price, Qty, Barcode, Brand, Model, Cost, Unit_Meas,
    Color, Size, Weight, Weight_Unit, Spec_Feat, Location, Upcode, Serialized,
    Assembly, Taxable, Last_Inv_Date, Freight_Cost, Last_Order_Date, Expect_Del,
    Qty_Last_Order, ReOrder_Pt, Last_Cost_Supp, Min_Price, Max_Price, Qty_Order,
    Warranty, Active, LastDate_Update, IsBoutique, IsFixAsset, IsRegularItem,
    IsAssetItem, IsTechnoCardRedeem, Cat_No_Asset, IsReprice, IsOrder, IsLoadSIM,
    IsPrintWarranty, Item_Pix_Filename, Item_Pix2_Filename, Item_Icon, ItemTempID,
    ReferRebatePercent, CreatedBy, DateCreated, ModifiedBy, DateModified,
    BullGuardPromo, IsPackage
    FROM inventory";

$stmt = $conn->prepare($sql);
if (!$stmt) {
    echo json_encode(["status" => "error", "message" => "SQL Error: " . $conn->error]);
    exit;
}

if (!$stmt->execute()) {
    echo json_encode(["status" => "error", "message" => "Failed to execute inventory query"]);
    exit;
}

// Bind all fields
$stmt->bind_result(
    $Item_No, $Item_Desc, $Item_Price, $Qty, $Barcode, $Brand, $Model, $Cost, $Unit_Meas,
    $Color, $Size, $Weight, $Weight_Unit, $Spec_Feat, $Location, $Upcode, $Serialized,
    $Assembly, $Taxable, $Last_Inv_Date, $Freight_Cost, $Last_Order_Date, $Expect_Del,
    $Qty_Last_Order, $ReOrder_Pt, $Last_Cost_Supp, $Min_Price, $Max_Price, $Qty_Order,
    $Warranty, $Active, $LastDate_Update, $IsBoutique, $IsFixAsset, $IsRegularItem,
    $IsAssetItem, $IsTechnoCardRedeem, $Cat_No_Asset, $IsReprice, $IsOrder, $IsLoadSIM,
    $IsPrintWarranty, $Item_Pix_Filename, $Item_Pix2_Filename, $Item_Icon, $ItemTempID,
    $ReferRebatePercent, $CreatedBy, $DateCreated, $ModifiedBy, $DateModified,
    $BullGuardPromo, $IsPackage
);

// Fetch results
$items = [];
while ($stmt->fetch()) {
    $items[] = [
        "Item_No" => (string)$Item_No,
        "Item_Desc" => $Item_Desc,
        "Item_Price" => $Item_Price,
        "Qty" => $Qty,
        "Barcode" => $Barcode,
        "Brand" => $Brand,
        "Model" => $Model,
        "Cost" => $Cost,
        "Unit_Meas" => $Unit_Meas,
        "Color" => $Color,
        "Size" => $Size,
        "Weight" => $Weight,
        "Weight_Unit" => $Weight_Unit,
        "Spec_Feat" => $Spec_Feat,
        "Location" => $Location,
        "Upcode" => $Upcode,
        "Serialized" => $Serialized,
        "Assembly" => $Assembly,
        "Taxable" => $Taxable,
        "Last_Inv_Date" => $Last_Inv_Date,
        "Freight_Cost" => $Freight_Cost,
        "Last_Order_Date" => $Last_Order_Date,
        "Expect_Del" => $Expect_Del,
        "Qty_Last_Order" => $Qty_Last_Order,
        "ReOrder_Pt" => $ReOrder_Pt,
        "Last_Cost_Supp" => $Last_Cost_Supp,
        "Min_Price" => $Min_Price,
        "Max_Price" => $Max_Price,
        "Qty_Order" => $Qty_Order,
        "Warranty" => $Warranty,
        "Active" => $Active,
        "LastDate_Update" => $LastDate_Update,
        "IsBoutique" => $IsBoutique,
        "IsFixAsset" => $IsFixAsset,
        "IsRegularItem" => $IsRegularItem,
        "IsAssetItem" => $IsAssetItem,
        "IsTechnoCardRedeem" => $IsTechnoCardRedeem,
        "Cat_No_Asset" => $Cat_No_Asset,
        "IsReprice" => $IsReprice,
        "IsOrder" => $IsOrder,
        "IsLoadSIM" => $IsLoadSIM,
        "IsPrintWarranty" => $IsPrintWarranty,
        "Item_Pix_Filename" => $Item_Pix_Filename,
        "Item_Pix2_Filename" => $Item_Pix2_Filename,
        "Item_Icon" => $Item_Icon,
        "ItemTempID" => $ItemTempID,
        "ReferRebatePercent" => $ReferRebatePercent,
        "CreatedBy" => $CreatedBy,
        "DateCreated" => $DateCreated,
        "ModifiedBy" => $ModifiedBy,
        "DateModified" => $DateModified,
        "BullGuardPromo" => $BullGuardPromo,
        "IsPackage" => $IsPackage
    ];
}
$stmt->close();

// Attach related data
if (!empty($items)) {
    $inventory_counts = fetch_inventory_counts($conn);
    // $branch_inventory = fetch_branch_inventory($conn);

    foreach ($items as &$item) {
        $item_no = (string)$item['Item_No'];
        $item['Inventory_Counts'] = $inventory_counts[$item_no] ?? [];
        $item['Branch_Inventory'] = $branch_inventory[$item_no] ?? [];
        $item['Total_Branch_Qty'] = isset($branch_inventory[$item_no]) ? array_sum($branch_inventory[$item_no]) : 0;
    }
}

$conn->close();

// Output
echo json_encode([
    "status" => !empty($items) ? "success" : "error",
    "message" => !empty($items) ? "Items fetched successfully" : "No items found",
    "data" => $items
]);
?>
